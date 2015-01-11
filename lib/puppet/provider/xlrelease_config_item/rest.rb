require_relative '../xlr_rest_provider.rb'
require 'json'
require 'pp'
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
    ci_json = {"title" => resource[:title], "type" => resource[:type], "properties" => resource[:properties] }.to_json
    pp ci_json

    rest_post "configurations", ci_json
  end

  def destroy
    rest_delete "configurations/#{configuration_id}"
  end

  def exists?
   p "exists"
   p get_config_item(resource[:title])
   return false if get_config_item(resource[:title]) == {}
   return true
  end

  def type
    get_config_item(resource[:title])[:type]
  end

  def type=(value)

    rest_put "configurations/#{configuration_id}", property_json
  end

  def properties
    p "props"
    p get_config_item(resource[:title])
    p get_config_item(resource[:title])
    get_config_item(resource[:title])["properties"]
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
    to_hash(rest_get("configurations"))
  end

  def get_config_item(title)

    config = get_config
    p config
    p "before config select"
    p config.class
    unless config.empty?
      p "config select"
      p config.select { |x| x["title"] == title }
      config_return =  config.select { |x| x["title"] == title }
      return {} if config_return.empty?
      return config_return.first
    end
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
    config_item["id"]
  end

end
