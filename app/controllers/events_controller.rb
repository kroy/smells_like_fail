class EventsController < ApplicationController
	def index
		@test = params[:match_id]
	end
end
