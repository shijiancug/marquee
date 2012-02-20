# == Schema Information
#
# Table name: users
#
#  id                   :integer         not null, primary key
#  email                :string(255)     default(""), not null
#  encrypted_password   :string(128)     default(""), not null
#  reset_password_token :string(255)
#  remember_created_at  :datetime
#  sign_in_count        :integer         default(0)
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  display_name         :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  acts_as_audited :except => [:password, :password_confirmation], :protect => false, :only => [:create, :destroy]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :display_name, :oracle_project_ids
  validates :email, :presence => true, :uniqueness => true

  has_many :projects
  has_and_belongs_to_many :roles
  has_many :automation_scripts
  has_many :test_suites
  has_many :oracle_project_permissions
  has_many :oracle_projects, :through => :oracle_project_permissions
  has_many :user_ability_definitions

  def self.automator
    User.find_by_email('automator@marquee.com')
  end

  def role?(role)
    return !!self.roles.find_by_name(role)
  end

  def update_role(role_id)
    role = Role.find(role_id)
    (self.roles.delete_all; self.roles << role) if role
    save
  end

  def update_oracle_projects(oracle_project_ids = [])
    self.oracle_projects.delete_all
    oracle_project_ids.each do |opi|
      oracle_project = OracleProject.find(opi)
      self.oracle_projects << oracle_project if oracle_project
    end
    save
  end

  def self.find_or_create_default_by_email(strEmail)
    u = User.find_by_email(strEmail)
    if u.nil?
      names = strEmail.split("@").first.split(".")    
      u = User.new(        
        :email => strEmail,
        :display_name => "#{names.first.capitalize} #{names.last.capitalize}",
        :password => "111111"
      )
      u.roles << Role.find_by_name("qa_developer")
      u.save
    end
    u  
  end
end