require 'jwt'

class JsonWebToken
  
  # Encodes and sign JWT Payload with expiration
  def self.encode(payload)
    payload.reverse_merge!(meta)
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end

  # Decodes the JWT with the signed secret
  def self.decode(token)
    JWT.decode(token, Rails.application.credentials.secret_key_base)
  end

  # Validates the payload hash for expiration and meta claims
  def self.valid_payload(payload)
    if expired(payload) || payload['iss'] != meta[:iss] || payload['aud'] != meta[:aud]
      return false
    else
      return true
    end
  end

  # Default options to be encoded in the token
  def self.meta
    {
      exp: 7.days.from_now.to_i,
      iss: 'issuer_name',
      aud: 'client'
    }
  end

  # Validates if the token is expired by exp parameter
  def self.expired(payload)
    Time.at(payload['exp']) < Time.now
  end

end
