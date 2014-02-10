class AutomationScriptResultsController < InheritedResources::Base
  respond_to :js
  belongs_to :test_round

  def update_triage_result
    automation_script_result = AutomationScriptResult.find(params[:id])
    triage_result = params[:triage_result]
    respond_to do |format|
      if automation_script_result.update_triage!(triage_result)
        result = automation_script_result.test_round.send_triage_mail?
        if not result
          automation_script_result.test_round.update_result
          TestRoundMailer.triage_mail(automation_script_result.test_round.id).deliver
        end
        format.js { render :json => {:result => "success", :tr_result => automation_script_result.test_round.result, :asr_result => automation_script_result.result}}
      else
        format.js { render :json => {:result => "failed", :tr_result => automation_script_result.test_round.result, :asr_result => automation_script_result.result}}
      end
    end
  end

  def rerun(automation_script_result_id=params[:id])
    automation_script_result = AutomationScriptResult.find(automation_script_result_id)
    automation_script_result.clear

    non_rerunned_asr = automation_script_result.test_round.automation_script_results.select {|asr| asr.state != "scheduling"}
    if non_rerunned_asr.nil? || non_rerunned_asr.empty?
      automation_script_result.test_round.start_time = nil
      automation_script_result.test_round.save
    end

    AutomationScriptResultRunner.rerun(automation_script_result_id)
    render :nothing => true
  end

  def stop
    asr = AutomationScriptResult.find(params[:id])
    if not asr.end?
      asr.state = "stopping"
      asr.save
      sa = asr.slave_assignments.last if asr
      SlaveAssignmentsHelper.send_slave_assignment_to_list sa, "stop" if sa
    end

    render :nothing => true
  end
  
  def show_logs
    @test_round ||= TestRound.find(params[:test_round_id])
    @project ||= @test_round.project
    @automation_script_result ||= AutomationScriptResult.find(params[:automation_script_result_id])
    @slave_assignment ||= @automation_script_result.slave_assignments.last
    #@start_time ||= (Time.parse(@automation_script_result.start_time.to_s) - 60).utc
    #@end_time ||= (Time.parse(@automation_script_result.end_time.to_s) + 60).utc
    #@searched_logs = SlaveLog.where(:ip => @slave_assignment.slave.ip_address,:timestamp.gt => @start_time,:timestamp.lt => @end_time).asc(:_id)
  end

  protected
  def resource
    @test_round ||= TestRound.find(params[:test_round_id])
    @project = @test_round.project
    @automation_script_result ||= AutomationScriptResult.find(params[:id])
    @search = @automation_script_result.automation_case_results.search(params[:search])
    @automation_case_results = @search.page(params[:page]).per(15)
    @automation_case_results.sort!{|acr1, acr2| acr1.case_id <=> acr2.case_id}
  end

  def collection
    @test_round ||= TestRound.find(params[:test_round_id])
    @search = @test_round.automation_script_results.search(params[:search])
    @automation_script_results ||= @search.order('id desc').page(params[:page]).per(15)
  end
end
