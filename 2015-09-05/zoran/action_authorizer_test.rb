require "minitest/autorun"

require 'yaml' # fixtures: ACL is defined in YAML file
ACL_FILE_PATH = "fixtures/acl.yml"

require "action_authorizer"
class ActionAuthorizerTest < Minitest::Test

  def setup
    @acl = YAML.load(File.read(ACL_FILE_PATH)) if File.exists?(ACL_FILE_PATH)
  end

  def test_action_authorized

    params = {"controller" => "sessions", "action" => "bar"}
    assert ActionAuthorizer.new(acl: @acl["everyone"], params: params).action_authorized?, "sessions is accessable to everyone"

    params = {"controller" => "admin/payloads/mdm_payloads", "action" => "bar"}
    assert ActionAuthorizer.new(acl: @acl["admins"], params: params).action_authorized?, "admin group is accessable for admins"

    params = {"controller" => "admin/payloads/mdm_payloads", "action" => "index"}
    assert ActionAuthorizer.new(acl: @acl["auditors"], params: params).action_authorized?, "admin group is accessable to auditors"

    params = {"controller" => "foo", "action" => "bar"}
    refute ActionAuthorizer.new(params: params).action_authorized?, "foo use-case"

    refute ActionAuthorizer.new(acl: @acl["everyone"], params: params).action_authorized?, "foo is not accessable to everyone"

    params = {"controller" => "foo/bar/baz", "action" => "index"}
    refute ActionAuthorizer.new(acl: @acl["admins"], params: params).action_authorized?, "foo group is not accessable to admins"

    # edge cases
    params = {"controller" => "", "action" => ""}
    refute ActionAuthorizer.new(params: params).action_authorized?, "empty params"

    assert_raises KeyError, "no args" do
      ActionAuthorizer.new.action_authorized?
    end

  end
end
