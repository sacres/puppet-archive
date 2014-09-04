module PuppetX
  module Bodeco
    module Util
      def download(url, filepath, options = {})
        username = options[:username] || nil
        password = options[:password] || nil
        uri = URI(url)
        @connection = PuppetX::Bodeco.const_get(uri.scheme.upcase).new("#{uri.scheme}://#{uri.host}:#{uri.port}", username, password)
        @connection.download(uri.path, filepath)
      end
    end

    class HTTP
      require 'faraday_middleware'
      def initialize(url, username, password)
        @connection = Faraday.new(url) do |conn|
          conn.basic_auth(username, password) if username and password

          conn.response :raise_error # This let's us know if the transfer failed.
          conn.response :follow_redirects, :limit => 5

          conn.adapter Faraday.default_adapter
        end
      end

      def download(url_path, file_path)
        f = File.open(file_path, 'wb')
        f.write(@connection.get(url_path).body)
        f.close
      rescue Faraday
        raise $!, "Unable to download file #{url_path}. #{$!}", $!.backtrace
      end
    end

    class HTTPS < HTTP
    end

    class FTP
      require 'net/http'
    end
  end
end
