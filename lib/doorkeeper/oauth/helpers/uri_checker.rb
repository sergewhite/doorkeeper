module Doorkeeper
  module OAuth
    module Helpers
      module URIChecker
        def self.valid?(url)
          uri = as_uri(url)
          uri.fragment.nil? && !uri.host.nil? && !uri.scheme.nil?
        rescue URI::InvalidURIError
          false
        end

        def self.matches?(url, client_url)
          url = as_uri(url)
          if Doorkeeper.configuration.wildcard_redirect_uri
            return true if url.to_s =~ /^#{client_url.to_s.gsub(/\*/, '.*?')}/
            false
          else
            url.query = nil
            url == as_uri(client_url)
          end
        end

        def self.valid_for_authorization?(url, client_url)
          valid?(url) && client_url.split.any? { |other_url| matches?(url, other_url) }
        end

        def self.as_uri(url)
          URI.parse(url)
        end

        def self.native_uri?(url)
          url == Doorkeeper.configuration.native_redirect_uri
        end
      end
    end
  end
end
