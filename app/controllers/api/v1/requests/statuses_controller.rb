# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::Requests::StatusesController < Api::V1::ApplicationController
    account_load_and_authorize_resource :status, through: :team, through_association: :requests_statuses

    # GET /api/v1/teams/:team_id/requests/statuses
    def index
    end

    # GET /api/v1/requests/statuses/:id
    def show
    end

    # POST /api/v1/teams/:team_id/requests/statuses
    def create
      if @status.save
        render :show, status: :created, location: [:api, :v1, @status]
      else
        render json: @status.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/requests/statuses/:id
    def update
      if @status.update(status_params)
        render :show
      else
        render json: @status.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/requests/statuses/:id
    def destroy
      @status.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def status_params
        strong_params = params.require(:requests_status).permit(
          *permitted_fields,
          :name,
          :slug,
          :color,
          # 🚅 super scaffolding will insert new fields above this line.
          *permitted_arrays,
          # 🚅 super scaffolding will insert new arrays above this line.
        )

        process_params(strong_params)

        strong_params
      end
    end

    include StrongParameters
  end
else
  class Api::V1::Requests::StatusesController
  end
end
