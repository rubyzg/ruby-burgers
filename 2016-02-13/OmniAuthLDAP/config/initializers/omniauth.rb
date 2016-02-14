require 'omniauth/strategies/net_ldap'

OmniAuth.config.logger = Rails.logger

# The default behavior is to redirect to /auth/failure
# except in the case of a development environment, in which case an exception will be raised
# so, this configures development to behave same as production
OmniAuth.config.on_failure = Proc.new { |env| OmniAuth::FailureEndpoint.new(env).redirect_to_failure }

Rails.application.config.middleware.use OmniAuth::Builder do

  provider :net_ldap, name: :ldap, connection_params: {
    :host => ENV['LDAP_HOST'],
    :port => ENV['LDAP_PORT'],
    :base => ENV['LDAP_BASE'],
    :encryption => :simple_tls,
    :auth_username => ENV['LDAP_BIND_USER'],
    :auth_password => ENV['LDAP_BIND_PASS'],
  }
end
