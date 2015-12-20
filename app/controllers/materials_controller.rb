class MaterialsController < ApplicationController
  before_action :set_material, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /materials
  # GET /materials.json
  def index
    @materials = Material.all
  end

  # GET /materials/1
  # GET /materials/1.json
  def show
  end

  # GET /materials/new
  def new
    
    @subjects = ["Matematicas" , "Biologia", "Quimica", "Fisica"];
    @Maths = File.read('clasifications/Math.json');
    @material = Material.new
  end

  # GET /materials/1/edit
  def edit
    @subjects = ["Matematicas" , "Biologia", "Quimica", "Fisica"];
    @Maths = File.read('clasifications/Math.json');
  end

  # POST /materials
  # POST /materials.json
  def create
    @material = Material.new(material_params)
    byebug
    respond_to do |format|
      if @material.save
        format.html { redirect_to @material, notice: 'Material was successfully created.' }
        format.json { render :show, status: :created, location: @material }
      else
        format.html { render :new }
        format.json { render json: @material.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /materials/1
  # PATCH/PUT /materials/1.json
  def update
    respond_to do |format|
      if @material.update(material_params)
        @material.account = current_user.id
        @material.uploadDate = DateTime.now
        @material.username = current_user.username
        format.html { redirect_to @material, notice: 'Material was successfully updated.' }
        format.json { render :show, status: :ok, location: @material }
      else
        format.html { render :edit }
        format.json { render json: @material.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /materials/1
  # DELETE /materials/1.json
  def destroy
    @material.destroy
    respond_to do |format|
      format.html { redirect_to materials_url, notice: 'Material was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_material
      @material = Material.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def material_params
      params[:material][:authors] = params[:material][:authors].split(",")
      params[:material][:tags] = params[:material][:tags].split(",")
      params.require(:material).permit(:name, :description, :type, :format, :link, :authors, :youtubeChannel, :tags, :subject, :searchable)
    end
end
