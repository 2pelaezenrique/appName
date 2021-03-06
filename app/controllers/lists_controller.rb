class ListsController < ApplicationController
  before_action :set_list, only: [:show, :edit, :update, :destroy]

  # GET /lists
  # GET /lists.json
  def index
    @lists = List.all
  end

  # GET /lists/1
  # GET /lists/1.json
  def show
  end
  def materialToList
    materialId = params[:material_id]
    listId = params[:list_id]
    if current_user.lists.where(id: listId).exists?
      @list = List.find(listId)
      if @list.materials.include?(materialId)
        @list.materials.delete(materialId)
        if @list.save
          render json: {}, status: :ok
        else
          render json: {}, status: :conflict
        end
      else
        if @list.push(materials: materialId)
          render json: {}, status: :ok
        else
          render json: {}, status: :conflict
        end
      end
    else
      render json: {}, status: :conflict
    end
  end
  # GET /lists/new
  def new
    @list = List.new
  end

  # GET /lists/1/edit
  def edit
  end

  # POST /lists
  # POST /lists.json
  def create
    @list = List.new(list_params)
    @list.user_id = current_user.id

    respond_to do |format|
      if @list.save
        format.json { render :json => {:name => @list.name, :description => @list.description, :id => @list.id.to_s}, status: :created }
      else
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lists/1
  # PATCH/PUT /lists/1.json
  def update
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to @list, notice: 'List was successfully updated.' }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { render :edit }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.json
  def destroy
    @list.destroy
    respond_to do |format|
      format.html { redirect_to lists_url, notice: 'List was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = List.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def list_params
      params.require(:list).permit(:name, :description, :public)
    end
end
