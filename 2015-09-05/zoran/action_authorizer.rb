# an action authorization for Rails app based on params["controller"] and params["action"]
class ActionAuthorizer
  attr_reader :acl, :controller, :action

  def initialize(acl: [], params: {})
    @acl        = acl
    @controller = params.fetch("controller")
    @action     = params.fetch("action")
  end

  def action_authorized?
    matched_actions.any?
  end

  private

  def matched_actions
    result = []
    # check for authorization rule if controller is in the controllers folder,
    # e.g. "admin/"
    result += match_actions_for(matched_top_controller_group)

    # then, authorize by controller
    result += match_actions_for(matched_controller)
    result
  end

  def match_actions_for(input)
    input.select{ |a| (a["actions"] == :any) || a["actions"].include?(action) }
  end

  def matched_top_controller_group
    acl.select{ |a| (a["controllers"] == :any) || (a["controllers"] == top_controller_group) }
  end

  def matched_controller
    acl.select{ |a| a["controller"] == controller }
  end

  # top_controller_group return top directory name,
  # e.g. "admin/payloads/mdm_payloads" => "admin/", (nil otherwise)
  def top_controller_group
    controller[/\A\w*\//] || []
  end
end
