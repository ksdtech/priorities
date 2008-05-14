class ItemsController < ApplicationController
  before_filter :login_required
  
  def index
    if request.post?
      params[:votes].each do |id, k_v|
        next unless k_v.key? :rank
        rank = k_v[:rank].to_i
        next unless rank >= 1 and rank <= 3
        v = current_user.votes.find_or_create_by_budget_item_id(id.to_i)
        v.update_attribute(:rank, rank)
      end
    end
    @items = BudgetItem.find(:all)
  end
  
  def report
    report_name = params[:weighted] ? 'weighted' : 'unweighted'
    @report = Report.find_by_name(report_name)
    @report.sort_weighted_items
  end

  protected
  
  def authorized?
    logged_in? && current_user.active?
  end

  def access_denied
    respond_to do |format|
      format.html do
        store_location
        render :template => 'users/login_required'
      end
      format.any do
        request_http_basic_authentication 'Web Password'
      end
    end
  end

end
