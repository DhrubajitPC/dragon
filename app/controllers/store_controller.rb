class StoreController < ApplicationController

	before_action :service, only: [:show, :create]

	def show
		resp = service.get_versioned_item(params)
		render json: resp[:response], status: resp[:status]
	end

	def create
		resp = service.create_versioned_item(store_params)
		render json: resp[:response], status: resp[:status]
	end

	private

	def service
		VersionService.new
	end

	def store_params
		_params = ActionController::Parameters.new
		req_params = JSON.parse(request.body.read)
		key = req_params.keys[0]
		value = req_params["#{key}"]
		_params[:key] = key
		_params[:value] = value
		_params.permit(:key, :value)
	end
	
end
