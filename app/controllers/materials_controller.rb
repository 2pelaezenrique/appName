class MaterialsController < ApplicationController
  before_action :set_material, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /materials
  # GET /materials.json
  def index
     @search = true;
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
    if params[:material][:format] == "file"
      @material.file = params[:material][:file]
      if file_type != "unsupported_File"
        @material.file_type = file_type
      end
    end
    if validate_format
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
    #Returns the Id of the youtube video url.
    def youtubeIdFrom(url)
      regex = /^.*(?:(?:youtu\.be\/|v\/|vi\/|u\/\w\/|embed\/)|(?:(?:watch)?\?v(?:i)?=|\&v(?:i)?=))([^#\&\?]*).*/
      result = regex.match(url)
      return result[1]
    end
    #Check if it is a supported file type or if it is a video
    def validate_format
      format = params[:material][:format]
      case format
      when "video"
        return true      
      when "file"
        if file_type = "unsupported_File"
          return false
        else
          return true
        end
      else
        return false
      end
    end
    
    #Check MIME Type and returns the type of the file (pdf, excel, slides, etc)
    def file_type
        file = params[:material][:file]
        case file.content_type
            when 'application/pdf'
              return "pdf"           
            when "mage/gif","image/bmp","image/jpeg",'image/png','image/x-icon','image/x-xbitmap'
              return "image"
            when "text/plain"
              return "plain_Text"
            when "application/msword","application/vnd.openxmlformats-officedocument.wordprocessingml.document","application/vnd.oasis.opendocument.text","application/vnd.sun.xml.writer","application/vnd.sun.xml.writer.global"
              return "text"
            when "application/vnd.openxmlformats-officedocument.presentationml.presentation","application/vnd.ms-powerpoint","application/vnd.ms-powerpoint.presentation.macroenabled.12"," application/vnd.sun.xml.impress","  application/vnd.sun.xml.impress.template","application/vnd.openxmlformats-officedocument.presentationml.slideshow","application/vnd.ms-powerpoint.presentation.macroenabled.12","application/vnd.oasis.opendocument.presentation"," application/vnd.oasis.opendocument.presentation-template"
             return "slides"
            when "application/vnd.ms-excel","application/vnd.ms-excel.sheet.binary.macroenabled.12","application/vnd.ms-excel.sheet.macroenabled.12","  application/vnd.openxmlformats-officedocument.spreadsheetml.sheet","application/vnd.sun.xml.calc"," application/vnd.oasis.opendocument.spreadsheet"
              return "excel"
            when "application/x-rar-compressed","application/x-tar","application/x-7z-compressed","application/zip"
              return "compressed_File"
            else
              return "unsupported_File"
        end                
    end 


    
end