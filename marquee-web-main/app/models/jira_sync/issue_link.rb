class IssueLink < ActiveRecord::Base

  establish_connection :jira_sub
  self.table_name = "issuelink"
end
