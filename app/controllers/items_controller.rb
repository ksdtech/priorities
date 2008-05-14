class ItemsController < ApplicationController
  before_filter :login_required
  
  # GET /items
  # GET /items.xml
  def index
    if request.post?
      params[:votes].each do |id, k_v|
        next unless k_v.key? :rank
        rank = k_v[:rank].to_i
        next unless rank >= 1 and rank <= 3
        v = current_user.votes.find_or_create_by_budget_item_id(id.to_i)
        v.update_attribute(:rank, rank)
      end
    else
      @admin = !params[:admin].nil?
    end
    @items = BudgetItem.find(:all)
  end
  
  def report
    report_name = params[:name] || 'unweighted'
    @report = Report.find(:first, :conditions => ['name=?', report_name])
    @report.sort_weighted_items
    @weighting = @report.discount_points != 0
  end
  
   # GET /items/new
   # GET /items/new.xml
   def new
     @item = BudgetItem.new

     respond_to do |format|
       format.html # new.html.erb
       format.xml  { render :xml => @item }
     end
   end

  # GET /items/1/edit
  def edit
    @item = BudgetItem.find(params[:id])
  end  
  
  # POST /items
  # POST /items.xml
  def create
    @item = BudgetItem.new(params[:budget_item])

    respond_to do |format|
      if @item.save
        flash[:notice] = 'Item was successfully created.'
        format.html { redirect_to(@item) }
        format.xml  { render :xml => @item, :status => :created, :location => @item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /items/1
  # PUT /items/1.xml
  def update
    @item = BudgetItem.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:budget_item])
        flash[:notice] = 'Item was successfully updated.'
        format.html { redirect_to(budget_items_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /items/1
  # DELETE /items/1.xml
  def destroy
    @item = item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to(budget_items_url) }
      format.xml  { head :ok }
    end
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
