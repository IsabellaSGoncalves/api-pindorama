class JsonWebToken
  SECRET_KEY = ENV["JWT_SECRET_KEY"]

  def self.encode(payload, exp = 24.hours.from_now)
    raise "JWT_SECRET_KEY não definida" unless SECRET_KEY

    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    raise "JWT_SECRET_KEY não definida" unless SECRET_KEY

    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  rescue JWT::DecodeError
    nil
  end
end
