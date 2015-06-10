settings = {}

if File.exist?('/etc/xlrelease/xlrelease.conf')
    File.open('/etc/xlrelease/xlrelease.conf').each do |line|
      key, value = line.split '=' , 2
      settings[key] = value
    end


  case settings['http.bind.address'].chomp
    when /0.0.0.0|localhost/
      settings['xlrelease.server.address'] = Facter.value('fqdn') || Facter.value('ipaddress')
    else
      settings['xlrelease.server.address'] = settings['http.bind.address']
  end


  settings['xlrelease.http.protocol'] = 'http'
  settings['xlrelease.http.protocol'] = 'https' if settings['ssl'] == true

  settings['xlrelease.rest.url'] = "#{settings['xlrelease.http.protocol']}://#{settings['xlrelease.server.address']}:#{settings['http.port'].chomp}#{settings['http.context.root']}"

  Facter.add("xlrelease_bind_dn") do
      setcode do
        settings['http.bind.address']
      end
  end

  Facter.add("xlrelease_http_port") do
      setcode do
        settings['http.port']
      end
  end

  Facter.add("xlrelease_context_root") do
      setcode do
        settings['http.context.root']
      end
  end

  Facter.add("xlrelease_ssl") do
      setcode do
        settings['ssl']
      end
  end

  Facter.add("xlrelease_server_address") do
    setcode do
      settings['xlrelease.server.address']
    end
  end

  Facter.add("xlrelease_rest_url") do
    setcode do
      settings['xlrelease.rest.url']
    end
  end

  Facter.add("xlrelease_encrypted_password") do
    setcode do
      settings['xlrelease.admin.password']
    end
  end
end
