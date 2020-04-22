require "openssl/hmac"

module BBBJoiner::Actions::Concerns
  module CSRF
    private SHA512 = OpenSSL::Algorithm::SHA512

    private def generate_csrf_token
      timestamp_ms = Time.utc.to_unix_ms.to_s
      hmac = OpenSSL::HMAC.hexdigest(SHA512, BBBJoiner.config.secret, timestamp_ms)
      {timestamp_ms, hmac}.join(':')
    end

    private def valid_csrf?(token)
      return false if token.nil?
      timestamp_ms, hmac = token.split(':')
      timestamp = Time.unix_ms(timestamp_ms.to_u64)
      return false if Time.utc - timestamp > 5.minutes

      OpenSSL::HMAC.hexdigest(SHA512, BBBJoiner.config.secret, timestamp_ms) == hmac
    end
  end
end
