class Account::RequestsController < Account::ApplicationController
  account_load_and_authorize_resource :request, through: :team, through_association: :requests

  # GET /account/teams/:team_id/requests
  # GET /account/teams/:team_id/requests.json
  def index
    delegate_json_to_api
  end

  # GET /account/requests/:id
  # GET /account/requests/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/requests/new
  def new
  end

  # GET /account/requests/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/requests
  # POST /account/teams/:team_id/requests.json
  def create
    respond_to do |format|
      if @request.save
        format.html { redirect_to [:account, @request], notice: I18n.t("requests.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @request] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/requests/:id
  # PATCH/PUT /account/requests/:id.json
  def update
    respond_to do |format|
      if @request.update(request_params)
        format.html { redirect_to [:account, @request], notice: I18n.t("requests.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @request] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/requests/:id
  # DELETE /account/requests/:id.json
  def destroy
    @request.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :requests], notice: I18n.t("requests.notifications.destroyed") }
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
