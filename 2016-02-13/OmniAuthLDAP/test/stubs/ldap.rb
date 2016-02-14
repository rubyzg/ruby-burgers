module Stubs
  class Ldap

    def bind_as(**args)
      if args[:password] == "correctpass"
        [ldap_entry_for_zm]
      else
        false
      end
    end

    def auth(user, pass)
      true
    end

    def get_operation_result
      Struct.new(:code, :inspect).new.tap do |obj|
        obj.code = Net::LDAP::ResultCodeSuccess
      end
    end

    private

    def ldap_entry_for_zm
      e = Net::LDAP::Entry.new "CN=Zoran Majstorovi\xC4\x87,CN=Users,DC=promdm,DC=net"
      e[:cn] = ["Zoran Majstorovi\xC4\x87"]
      e[:sn] = ["Majstorovi\xC4\x87"]
      e[:givenname]   = ["Zoran"]
      e[:displayname] = ["Zoran Majstorovi\xC4\x87"]
      e[:memberof]    = [
        "CN=promdmadmins,CN=Users,DC=promdm,DC=net",
        "CN=Domain Admins,CN=Users,DC=promdm,DC=net",
      ]
      e[:name]              = ["Zoran Majstorovi\xC4\x87"]
      e[:samaccountname]    = ["zm"]
      e[:userprincipalname] = ["zm@promdm.net"]
      e[:mail]              = ["zm@promdm.net"]
      e
    end
  end
end
