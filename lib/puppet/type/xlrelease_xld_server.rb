require 'pathname'

Puppet::Type.newtype(:xlrelease_xld_server) do
  @doc = 'Manage a XL Deploy Configuration Item'

  feature :restclient, 'Use REST to update XL Deploy repository'

  ensurable do
    defaultvalues
    defaultto :present
  end

  autorequire(:class) do
    'xlrelease'
  end


  newparam(:id, :namevar => true) do
    desc 'The ID/path of the CI'

    # validate do |value|
    #  raise Puppet::Error, "Invalid id: #{value}" unless value =~ /^(Applications|Environments|Infrastructure|Configuration)\/.+$/
    # end


    munge do |value|
      "Configuration/Deployit/#{value}"
    end

  end

  newparam(:type) do
    desc 'Type of the CI: usually xlrelease.DeployitServerDefinition'
    defaultto 'xlrelease.DeployitServerDefinition'
  end

  newproperty(:properties) do
    desc 'Properties of the CI'

    defaultto({})

    validate do |value|
      raise Puppet::Error, "Invalid properties: #{value}, expected a hash" unless value.is_a? Hash
    end

    # We need to overwrite insync? to verify only the properties that we
    # manage, because XL Deploy also returns all properties of a CI, which
    # could include properties that are not set by puppet
    def insync?(is)
      compare(is, @should.first) and compare(@should.first, is)
    end

    def compare(is, should)
      return false unless is.class == should.class

      if should.is_a? Hash
        should.each do |k, v|
          return false unless is.has_key? k and compare(is[k], should[k])
        end
      elsif should.is_a? Array
        should.each do |a|
          return false unless is.include? a
        end
      else
        return false unless is == should
      end

      true
    end

    def should_to_s(newvalue)
      newvalue.inspect
    end

    def is_to_s(currentvalue)
      currentvalue.inspect
    end
  end


  newparam(:rest_url, :required_features => ['restclient']) do
    desc 'The rest url for making changes to XL Deploy'
  end

end
