require_relative '../xlr_rest_provider.rb'

Puppet::Type.type(:xlrelease_config_item).provide :rest, :parent => Puppet::Provider::XLReleaseRestProvider do

  has_feature :restclient


  def self.instances
    xlrelease_config_items = rest_get "configurations".collect do |config_hash|
      new( :type        => config_hash["type"],
           :title       => config_hash["title"],
           :properties  => config_hash["properties"],
           :ensure      => :present,
           :id          => config_hash["id"]
      )
    end
  end

  def self.prefetch(resources)
    xlrelease_config_items = instances
    resources.keys.each do |title|
      if provider = xlrelease_config_items.find{ |cfi| cfi.title == title }
        resources[name].provider = provider
      end
    end
  end

  def create
    property_json = {
        :type        => resource[:type],
        :title       => resource[:title],
        :properties  => resource[:properties],
        :ensure      => :present,
        }.to_j
    rest_post "configurations", property_json
    @property_hash[:ensure] = :present
  end

  def destroy
    rest_delete "configurations/#{@property_hash[:id]}"
    @property_hash[:ensure] = :absent
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def type
    @property_hash[:type]
  end

  def type=(value)
    @property_flush[:type] = value
  end

  def properties
    @property_hash[:properties] || {}
  end

  def properties=(value)
    @property_flush[:properties] = properties.merge(value)
  end

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def flush
    options {}
    if @property_flush
      options = {
          :type        => resource[:type],
          :title       => resource[:title],
          :properties  => resource[:properties],
          :ensure      => :present,
      }
    rest_put "configurations/#{@property_hash[:id]}", options.to_j
    end
  end


end
