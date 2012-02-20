# == Schema Information
#
# Table name: mail_notify_settings
#
#  id           :integer         not null, primary key
#  mail         :string(255)
#  project_id   :integer
#  test_type_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class MailNotifySetting < ActiveRecord::Base
  belongs_to :project
  has_and_belongs_to_many :test_types
  has_and_belongs_to_many :mail_notify_groups

  def groups
    mail_notify_groups.collect{|mng| mng.name}.join(', ')
  end

  def all_test_types
    test_types.collect{|tt| tt.name}.join(', ')
  end
end