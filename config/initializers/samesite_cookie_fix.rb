Rails.application.config.middleware.insert_after ActionDispatch::Cookies, ->(env) {
  status, headers, response = Rails.application.call(env)

  if headers['Set-Cookie' ]
    headers['Set-Cookie'] = headers['Set-Cookie'].gsub(/SameSite=Lax/, 'SameSite=None; Secure')
  end

  [status, headers, response]
}
