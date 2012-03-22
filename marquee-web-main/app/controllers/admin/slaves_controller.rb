class Admin::SlavesController < InheritedResources::Base

  layout 'admin'
  before_filter :authenticate_user!
  load_and_authorize_resource

  def create

    create!{admin_slaves_url}
  end

  def update

    update!{admin_slaves_url}
  end

end
