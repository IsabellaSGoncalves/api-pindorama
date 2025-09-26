class ForceSameSiteNoneMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)

    if headers["Set-Cookie"]
      cookies = headers["Set-Cookie"].split("\n").map do |cookie|
        cookie = cookie.gsub(/;?\s*SameSite=[^;]*/, "")
        cookie += "; SameSite=None; Secure"
        cookie
      end
      headers["Set-Cookie"] = cookies.join("\n")
    end

    [status, headers, response]
  end
end

Rails.application.config.middleware.insert_after ActionDispatch::Cookies, ForceSameSiteNoneMiddleware
