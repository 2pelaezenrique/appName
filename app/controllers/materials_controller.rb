class MaterialsController < ApplicationController
  before_action :set_material, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /materials
  # GET /materials.json
  def index
     @subjects = ["Matematicas" , "Biologia", "Quimica", "Fisica"];
     if request.query_parameters
        query = {}
        request.query_parameters.each do  |key,value|
          if key != "utf8" && key != "commit" && value != ""
            query[key] = value
          end
        end
        query[:searchable] = true
        @materials = Material.where(query)
     else
        @materials = Material.where(:searchable => true)
     end
  end

  # GET /materials/1
  # GET /materials/1.json
  def show
  end

  # GET /materials/new
  def new
    
    @subjects = ["Matematicas" , "Biologia", "Quimica", "Fisica"];
    @Maths = File.read('clasifications/Math.json');
    @Schools = File.read('clasifications/Schools.json');
    @material = Material.new
  end

  # GET /materials/1/edit
  def edit
    @subjects = ["Matematicas" , "Biologia", "Quimica", "Fisica"];
    @Maths = File.read('clasifications/Math.json');
    @Schools = File.read('clasifications/Schools.json');
  end

  # POST /materials
  # POST /materials.json
  def create
    @material = Material.new(material_params)
    @material.authors = params[:material][:authors]
    @material.tags = params[:material][:tags]
    @material.schools = params[:material][:schools]
    @material.user_id = current_user.id
    @material.uploadDate = DateTime.now
    @material.username = current_user.username
    byebug 
    if params[:material][:format] == 
      
    end
    @material.file = params[:material][:file]
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
        @material.authors = params[:material][:authors]
        @material.tags = params[:material][:tags]
        @material.updateDate = DateTime.now
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
      params[:material][:schools] = params[:material][:schools].split(",")
      params.require(:material).permit(:name, :description, :type, :format, :link, :authors, :youtubeChannel, :tags, :subject, :searchable, :schools)
    end
    def check_file
      format = params[:material][:format]
      file = params[:material][:file]
      case format
      when "pdf"
         if file.content_type == 'application/pdf'
          return true           
         end
      when "image"
        
         case file.content_type
         when "mage/gif","image/bmp","image/jpeg",'image/png','image/x-icon','image/x-xbitmap'
           return true
         else
          return false
         end
      
      when "word"
      
      else
        return false
      end

    end
end
