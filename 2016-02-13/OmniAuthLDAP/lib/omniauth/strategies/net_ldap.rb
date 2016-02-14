require 'omniauth'
require 'ldap_client'

module OmniAuth
  module Strategies
    class NetLDAP
      include OmniAuth::Strategy

      # option :form, SessionsController.action(:new)
      option :uid_label, 'email'
      option :uid_field, 'mail'
      option :return_attributes, LdapClient::DEFAULT_ATTRIBUTES

      def request_phase
        f = OmniAuth::Form.new(title: (options[:title] || "LDAP Authentication"), url: callback_path)
        f.text_field options.uid_label, options.uid_field
        f.password_field 'password', 'password'
        f.button "Sign In"
        f.to_response
      end

      def callback_phase
        # The goal of the callback phase is simply to set omniauth.auth to an AuthHash and then call through to the app
        return fail!(:missing_credentials) if missing_credentials?

        ldap_client = LdapClient.new(options.connection_params)
        return fail!(:ldap_client_fail) unless ldap_client

        @raw_info = ldap_client.authenticate_with(ldap_authentication_params)
        Rails.logger.debug "LDAP @raw_info was: #{@raw_info}"

        if @raw_info # successful authentication
          super      # redirect to /auth/:provider/callback
        else
          @raw_info = {}
          fail!(:invalid_credentials)
        end

      rescue LdapClient::ConnectionError
        fail!(:ldap_client_connection_error)
      end

      uid { request.params[options.uid_field] }

      info do
        {
          'upn'          => @raw_info[:userprincipalname],
          'name'         => @raw_info[:name],
          'email'        => @raw_info[:mail],
          'nickname'     => @raw_info[:samaccountname],
          'first_name'   => @raw_info[:givenname],
          'last_name'    => @raw_info[:sn],
          'display_name' => @raw_info[:displayname],
        }
      end

      extra do
        {
          'raw_info'  => @raw_info
        }
      end

      private

      def missing_credentials?
        (request[options.uid_field].to_s == '') || (request['password'].to_s == '')
      end

      def ldap_authentication_params
        {
          uid_field:         options.uid_field,
          uid:               request[options.uid_field],
          password:          request['password'],
          return_attributes: options.return_attributes,
        }
      end
    end
  end
end
OmniAuth.config.add_camelization 'net_ldap', 'NetLDAP'
