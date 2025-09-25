if Rails.env.development?
  Rails.application.config.session_store :cookie_store,
    key: "_pindorama_session",
    same_site: :lax
else
  Rails.application.config.session_store :cookie_store,
    key: "_pindorama_session",
    same_site: :none,
    secure: true,
    expire_after: 4.hours
end
