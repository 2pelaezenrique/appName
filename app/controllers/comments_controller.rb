class CommentsController < ApplicationController
	def create
		@comment = Material.find(params[:material_id]).comments.new()
		@comment.body = params[:body]
		@comment.user_id = current_user.id
		respond_to do |format|
        if @comment.save
          format.html { redirect_to material_path(params[:material_id]), notice: 'Comment was successfully created.' }
          
        else
          format.html { render material_path(params[:material_id]) }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end  
	end
end
