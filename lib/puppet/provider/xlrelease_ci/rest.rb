require_relative '../xlr_rest_provider.rb'

Puppet::Type.type(:xlrelease_ci).provide :rest, :parent => Puppet::Provider::XLReleaseRestProvider do

  has_feature :restclient

  def create
    ensure_parent_directory("#{resource[:id]}")

    ci_json = to_json(resource[:id],resource[:type],resource[:properties])
    rest_post "repository/ci/#{resource[:id]}", ci_json

  end

  def destroy
    rest_delete "repository/ci/#{resource[:id]}"
  end

  def exists?
    resource_exists?(resource[:id])
  end

  def properties
    ci_json = rest_get "repository/ci/#{resource[:id]}"
    ci_hash = to_hash(ci_json)

    # Add unmanaged k/v pairs that XL Deploy returns to our properties.
    # Otherwise these will be reset when updating any other property.
    ci_hash.each do |k, v|
      resource[:properties][k] = v unless resource[:properties].include? k

      # Temporarily replace password properties as well, until we can
      # encode passwords ourselves
      resource[:properties][k] = v if (k == 'password' or k == 'passphrase') and v.start_with?('{b64}')
    end
    ci_hash
  end

  def properties=(value)
    ci_json = to_json(resource[:id],resource[:type],resource[:properties])
    rest_put "repository/ci/#{resource[:id]}", ci_json
  end

  def ensure_parent_directory(id)
    # check if the parent tree parent of this ci exists.

    # get the parent name
    parent = Pathname.new(id).dirname.to_s

    # if the parent exists do nothing
    unless resource_exists?(parent)
      # ensure that the parent of this parent exists..
      # this builds a recursive loop wich loops over the entire path of the ci
      # until it finds a parent that is created
      # and will create all parents until the final one
      ensure_parent_directory(parent)

      # if the parent of this parent exists the create this one as a core.Directory
      parent_json = to_json(parent, 'core.Directory', {} )
      rest_post "repository/ci/#{parent}", parent_json
    end
  end

  def resource_exists?(id)
    # check if a certain resource exists in the XL Deploy repository
    ci_exists?(id)
  end
end
