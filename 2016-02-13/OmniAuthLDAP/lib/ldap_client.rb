class LdapClient
  attr_accessor :options

  ConnectionError = Class.new(StandardError)
  DEFAULT_ATTRIBUTES = [:dn, :cn, :givenname, :sn, :userprincipalname, :displayname, :name, :samaccountname, :mail].freeze

  def initialize(options = {})
    @options = options.symbolize_keys.freeze
  end

  # check user credentials with LDAP #bind_as method (used in Omniauth custom strategy NetLDAP)
  def authenticate_with(uid_field:, uid:, password:, return_attributes:)
    filter = Net::LDAP::Filter.eq(uid_field, uid)
    bind_as_params = { size: 1, filter: filter, password: password, attributes: return_attributes }
    bind_as_params[:base] = options[:base] if options[:base]
    bind_as_result = ldap.bind_as(bind_as_params)
    if successful_ldap_operation?
      sanitize(result: bind_as_result, return_attributes: return_attributes)
    else
      failed_operation
    end

  rescue Net::LDAP::Error => e
    Rails.logger.error "[LdapClient#authenticate_with] Net::LDAP::Error: #{e}"
    raise ConnectionError, e
  end

  private

  def successful_ldap_operation?
    ldap.get_operation_result.code == Net::LDAP::ResultCodeSuccess
  end

  def failed_operation
    Rails.logger.error "LDAP get_operation_result was: #{ldap.get_operation_result.inspect}"
    false
  end

  def ldap
    @ldap ||= begin
      args = { host: options.fetch(:host), port: options.fetch(:port, default_port) }
      args[:base] = options[:base] if options[:base]
      args[:encryption] = encryption_hash if options[:encryption]

      # a Hash containing authorization parameters
      # currently supported values include:
      #   :anonymous
      #   {:method => :simple, :username => your_user_name, :password => your_password }
      # The password parameter may be a Proc that returns a String.
      args[:auth] = auth_hash || :anonymous

      Net::LDAP.new(args)
    end
  end

  def auth_hash
    if options[:auth_username] && options[:auth_password]
      { method: :simple, username: options[:auth_username], password: options[:auth_password] }
    end
  end

  def encryption_hash
    # specifies the encryption to be used in communicating with the LDAP server
    case options[:encryption].to_s
    when "simple_tls"
      # { method: :simple_tls, tls_options: OpenSSL::SSL::SSLContext::DEFAULT_PARAMS }
      { method: :simple_tls }

    # when "start_tls"
    #   { method: :start_tls,  tls_options: { ca_file: "cafile.pem", ssl_version: "TLSv1_1" } }
    end
  end

  def default_port
    options[:encryption] ? 636 : 389
  end

  def sanitize(result:, return_attributes:)
    return false if result.blank? || result.first.blank?
    first_result = result.first
    return_attributes.inject({}) do |out, a|
      value = first_result[a]
      if value.size > 1
        out[a] = value.map{ |r| r.to_s.force_encoding(Encoding::UTF_8) }
      else
        out[a] = value.first.to_s.force_encoding(Encoding::UTF_8)
      end
      out
    end
  end

end
