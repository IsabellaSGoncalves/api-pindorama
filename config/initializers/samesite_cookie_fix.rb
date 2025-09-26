class ForceSameSiteNoneMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)

    if headers['Set-Cookie']
      headers['Set-Cookie'] = headers['Set-Cookie'].gsub(/SameSite=Lax/, 'SameSite=None; Secure')
    end

    [status, headers, response]
  end
end

Rails.application.config.middleware.insert_after ActionDispatch::Cookies, ForceSameSiteNoneMiddleware
