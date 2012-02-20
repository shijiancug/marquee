class Admin::TestRoundsController < InheritedResources::Base
  belongs_to :project
  respond_to :js
  layout 'admin'
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  protected
  def resource
    @project ||= Project.find(params[:project_id])
    @test_round ||= TestRound.find(params[:id])
  end

  def collection
    @project ||= Project.find(params[:project_id])
    @search = @project.test_rounds.order('id desc').search(params[:search])
    @admin_test_rounds ||= @search.page(params[:page]).per(15)
  end
end