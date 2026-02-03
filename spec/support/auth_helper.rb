module AuthHelper
  def auth_headers(user)
    token = user.generate_access_token
    { 'Authorization' => "Bearer #{token}" }
  end

  def authenticated_user
    user = create(:user)
    user.user_roles.create!(role: create(:role, name: 'user'))
    user
  end

  def admin_user
    user = create(:user)
    user.user_roles.create!(role: create(:role, name: 'admin'))
    user
  end
end

RSpec.configure do |config|
  config.include AuthHelper, type: :request
end
