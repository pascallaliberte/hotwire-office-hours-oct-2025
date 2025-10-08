class Account::Requests::StatusesController < Account::ApplicationController
  include SortableActions
  account_load_and_authorize_resource :status, through: :team, through_association: :requests_statuses

  # GET /account/teams/:team_id/requests/statuses
  # GET /account/teams/:team_id/requests/statuses.json
  def index
    delegate_json_to_api
  end

  # GET /account/requests/statuses/:id
  # GET /account/requests/statuses/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/requests/statuses/new
  def new
  end

  # GET /account/requests/statuses/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/requests/statuses
  # POST /account/teams/:team_id/requests/statuses.json
  def create
    respond_to do |format|
      if @status.save
        format.html { redirect_to [:account, @status], notice: I18n.t("requests/statuses.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @status] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/requests/statuses/:id
  # PATCH/PUT /account/requests/statuses/:id.json
  def update
    respond_to do |format|
      if @status.update(status_params)
        format.html { redirect_to [:account, @status], notice: I18n.t("requests/statuses.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @status] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/requests/statuses/:id
  # DELETE /account/requests/statuses/:id.json
  def destroy
    @status.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :requests_statuses], notice: I18n.t("requests/statuses.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
