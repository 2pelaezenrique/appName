class FavoritesController < ApplicationController
	before_action :authenticate_user!
	def create
		
		#params --> :material_id
		@favorite = Favorite.new
	    @favorite.user_id = current_user.id
	    @favorite.material_id = params[:material_id]
	    #Is ajax?
	    if request.env["HTTP_X_REQUESTED_WITH"] == "XMLHttpRequest"
			#Hasn't this user favorited this material? 
			if !alreadyInFavs?(params[:material_id])
				if @favorite.save
			        render json: {}, status: :ok
			    else
			    	render json: @favorite.errors, status: :unprocessable_entity
			    end	
			else
				render json: {}, status: :conflict
			end
	      
		end
	end
	def destroy
		@favorite = Favorite.where({user_id: current_user.id}).first
		@favorite.destroy
		render json: {}, status: :ok
	end

	private
	
	def alreadyInFavs?(material_id)
		if Favorite.and({ user_id: current_user.id }, { material_id: params[:material_id] }).count >= 1
			return true
		else
			return false 
		end
	end


end
