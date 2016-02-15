OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "1654292238170272", "09d3d83c3b92cc1a6f34eed1e2c5c6b4", :display => 'popup'
end
