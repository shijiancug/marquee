class Jira::ChangeItem
  include Mongoid::Document
  
  field :jira_id, type: String
  field :jira_field, type: String
  field :old_value, type: String
  field :new_value, type: String
  field :old_string, type: String
  field :new_string, type: String
  field :author, type: String
  field :change_date, type: DateTime

  embedded_in :issue, class_name: 'Jira::Issue', inverse_of: :change_items
end