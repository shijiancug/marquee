require 'csv'
class TestRoundsController < InheritedResources::Base
  respond_to :js
  respond_to :csv
  belongs_to :project
  before_filter :authenticate_user!, :only => [:new, :crete]


  def rerun
    test_round = TestRound.find(params[:test_round_id])
    test_round.automation_script_results.each do |asr|
      asr.clear
      non_rerunned_asr = asr.test_round.automation_script_results.select {|asr| asr.state != "scheduling"}
      if non_rerunned_asr.nil? || non_rerunned_asr.empty?
        asr.test_round.start_time = nil
        asr.test_round.save
      end
      AutomationScriptResultRunner.rerun(asr.id)
    end
    render :nothing => true
  end

  def create
    create! do
      @test_round.set_default_value
      @test_round.save
      # AutomationScriptResultsInitializer.createAutomationScriptResults(@test_round.id)
      TestRoundDistributor.distribute(@test_round.id)
      project_test_rounds_path(@project)
    end
  end

  def save_to_testlink
    SaveResultToTestlink.save(params[:test_round_id],params[:dev_key],params[:project_name],params[:test_plan_name],params[:build_name],params[:platform_name],params[:email])
   render :nothing => true
  end

  protected
    def resource
      @project ||= Project.find(params[:project_id])
      @test_round ||= TestRound.find(params[:id])
      @search = @test_round.automation_script_results.search(params[:search])
      @automation_script_results = @search.order('id desc').page(params[:page]).per(15)
    end

    def collection
      @project ||= Project.find(params[:project_id])
      @search = @project.test_rounds.search(params[:search])
      @test_rounds ||= @search.order('id desc').page(params[:page]).per(15)
    end

end
