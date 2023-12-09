class SubscriptionsController < ApplicationController
  before_action :check_logon
  before_action :set_subscription, only: %i[ show edit update destroy ]
  before_action :set_forum, only: %w[new create]

  # GET /subscriptions or /subscriptions.json
  def index
    @forums = Forum.find_by_sql("SELECT forums.* from forums JOIN subscriptions ON forums.id = forum_id WHERE user_id = $1 ORDER BY priority",[@user.id])
  end

  # GET /subscriptions/1 or /subscriptions/1.json
  def show
  end

  # GET /subscriptions/new
  def new
    if @forum.subscriptions.where(user_id: @user.id).any?
      redirect_to forums_path, notice: "You are already subscribed to that forum."
    end
    @subscription = @user.subscriptions.new
    @subscription.forum_id = @forum.id
  end

  # GET /subscriptions/1/edit
  def edit
  end

  # POST /subscriptions or /subscriptions.json
  def create
    @subscription = @user.subscriptions.new(subscription_params)
    @subscription.forum_id = @forum.id       
    
    respond_to do |format|
      if @subscription.save
        format.html { redirect_to subscription_url(@subscription), notice: "Subscription was successfully created." }
        format.json { render :show, status: :created, location: @subscription }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subscriptions/1 or /subscriptions/1.json
  def update
    respond_to do |format|
      if @subscription.update(subscription_params)
        format.html { redirect_to subscription_url(@subscription), notice: "Subscription was successfully updated." }
        format.json { render :show, status: :ok, location: @subscription }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscriptions/1 or /subscriptions/1.json
  def destroy
    @subscription.destroy

    respond_to do |format|
      format.html { redirect_to subscriptions_url, notice: "Subscription was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subscription
      @subscription = Subscription.find_by(id: params[:id], user_id: @user.id)
    end

    # Only allow a list of trusted parameters through.
    def subscription_params
      params.require(:subscription).permit(:forum_id, :user_id, :priority)
    end

    def set_forum
      @forum = Forum.find params[:forum_id]
    end    
    
    def check_logon 
      if !session[:current_user]
        redirect_to forums_path, notice: "You can't access subscriptions unless you are logged in."
      else 
        @user = User.find(session[:current_user]["id"])  # we'll need this!
      end
    end
end
