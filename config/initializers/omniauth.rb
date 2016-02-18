OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "1654292238170272", "09d3d83c3b92cc1a6f34eed1e2c5c6b4", :display => 'popup'
  provider :google_oauth2, "993035900172-85d1g1r1585tq0ktvrurco4u11efks85.apps.googleusercontent.com", "aSZq6to8UzqH4BqXRP5yjUwM",
   image_aspect_ratio: 'square', image_size: 48, access_type: 'online', name: 'google'
end
