require_relative '../xlr_rest_provider.rb'
require 'json'
require 'pp'
Puppet::Type.type(:xlrelease_config_item).provide :rest, :parent => Puppet::Provider::XLReleaseRestProvider do

  has_feature :restclient



  def create
    rest_post "configurations", property_json
  end

  def destroy
    rest_delete "configurations/#{configuration_id}"
  end

  def exists?
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
   get_config_item(resource[:title])["properties"].select{|k,v| v != nil }


  end

  def properties=(value)
    rest_put "configurations/#{configuration_id}", property_json
  end


  private
  def get_config
    to_hash(rest_get("configurations"))
  end

  def get_config_item(title)

    config = get_config

    unless config.empty?
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
    }.to_json
  end

  def configuration_id
    config_item = get_config_item(resource[:title])
    return nil if config_item == {}
    config_item["id"]
  end

end
