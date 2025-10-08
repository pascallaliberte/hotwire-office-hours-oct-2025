class Account::CustomersController < Account::ApplicationController
  account_load_and_authorize_resource :customer, through: :team, through_association: :customers

  # GET /account/teams/:team_id/customers
  # GET /account/teams/:team_id/customers.json
  def index
    delegate_json_to_api
  end

  # GET /account/customers/:id
  # GET /account/customers/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/customers/new
  def new
  end

  # GET /account/customers/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/customers
  # POST /account/teams/:team_id/customers.json
  def create
    respond_to do |format|
      if @customer.save
        format.html { redirect_to [:account, @customer], notice: I18n.t("customers.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @customer] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/customers/:id
  # PATCH/PUT /account/customers/:id.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to [:account, @customer], notice: I18n.t("customers.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @customer] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/customers/:id
  # DELETE /account/customers/:id.json
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :customers], notice: I18n.t("customers.notifications.destroyed") }
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
