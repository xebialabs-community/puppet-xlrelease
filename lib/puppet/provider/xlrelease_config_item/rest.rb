require_relative '../xlr_rest_provider.rb'
require 'json'
Puppet::Type.type(:xlrelease_config_item).provide :rest, :parent => Puppet::Provider::XLReleaseRestProvider do

  has_feature :restclient


  # def self.instances
  #   #configurations_hash = to_hash(rest_get("configurations"))
  #   xlrelease_config_items = to_hash(rest_get("configurations")).collect do |config_hash|
  #     new( :type        => config_hash["type"],
  #          :title       => config_hash["title"],
  #          :properties  => config_hash["properties"],
  #          :ensure      => :present,
  #          :id          => config_hash["id"]
  #     )
  #   end
  # end
  #
  # def self.prefetch(resources)
  #   xlrelease_config_items = instances
  #   resources.keys.each do |title|
  #     if provider = xlrelease_config_items.find{ |cfi| cfi.title == title }
  #       resources[name].provider = provider
  #     end
  #   end
  # end

  def create
    rest_post "configurations", property_json
  end

  def destroy
    rest_delete "configurations/#{configuration_id}"
  end

  def exists?
   return false if get_config_item(resource[:title]).nil?
   return true
  end

  def type
    get_config_item(resource[:title])[:type]
  end

  def type=(value)

    rest_put "configurations/#{configuration_id}", property_json
  end

  def properties
    get_config_item(resource[:title])[:properties]
  end

  def properties=(value)
    rest_put "configurations/#{configuration_id}", property_json
  end

  # def initialize(value={})
  #   super(value)
  #   @property_flush = {}
  # end
  #
  # def flush
  #   options {}
  #   if @property_flush
  #     options = {
  #         :type        => resource[:type],
  #         :title       => resource[:title],
  #         :properties  => resource[:properties],
  #         :ensure      => :present,
  #     }
  #   rest_put "configurations/#{@property_hash[:id]}", options.to_j
  #   end
  # end
  private
  def get_config
    p "get_config"
    p rest_get("configurations")
    to_hash(rest_get("configurations")).collect do |config_hash|
      new( :type        => config_hash["type"],
           :title       => config_hash["title"],
           :properties  => config_hash["properties"],
           :id          => config_hash["id"]
      )
      end
  end

  def get_config_item(title)
    p "get_config_item"
    p get_config.select { |x| x[:title] == title }
    config = get_config
    return config.select { |x| x[:title] == title } unless config == []
    return {}
  end

  def property_json
    {
      :type        => resource[:type],
      :title       => resource[:title],
      :properties  => resource[:properties],
      :ensure      => :present,
    }.to_json
  end

  def configuration_id
    config_item = get_config_item(resource[:title])
    return nil if config_item == {}
    config_item[:id]
  end

end
