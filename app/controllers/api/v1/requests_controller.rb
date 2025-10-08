# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::RequestsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :request, through: :team, through_association: :requests

    # GET /api/v1/teams/:team_id/requests
    def index
    end

    # GET /api/v1/requests/:id
    def show
    end

    # POST /api/v1/teams/:team_id/requests
    def create
      if @request.save
        render :show, status: :created, location: [:api, :v1, @request]
      else
        render json: @request.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/requests/:id
    def update
      if @request.update(request_params)
        render :show
      else
        render json: @request.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/requests/:id
    def destroy
      @request.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def request_params
        strong_params = params.require(:request).permit(
          *permitted_fields,
          :customer_id,
          :status_id,
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
  class Api::V1::RequestsController
  end
end
