class MaterialsController < ApplicationController
  before_action :set_material, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:index, :show]
  # GET /materials
 
  # GET /materials.json
  def index

     #favorites of a user Material.where(:'favorites.user_id' => current_user.id)
     @subjects = ["Matematicas" , "Biologia", "Quimica", "Fisica"]
     if request.query_parameters
        query = {}
        request.query_parameters.each do  |key,value|
          if key != "utf8" && key != "commit" && value != "" && key != "search"
            query[key] = value
          end
          
          if key == "search" && value != ""
            valueSplitted = value.split(" ")
            regepxString = String
            valueSplitted.each_with_index do  |word , index|
              regepxString = "(?=.*" + word + ")"

              if index == valueSplitted.length - 1
                regepxString += ".*"
              end
            end            
            regexp = Regexp.new(regepxString, true) 
            query["name"] = regexp 
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
    if @material.format == "video"
      @iframe = %Q'<iframe id="player" src="http://www.youtube.com/embed/#{@material.youtube_id}?&rel=0&theme=light&showinfo=0&color=white" frameborder="0" allowfullscreen></iframe>'.html_safe
      render 'show_video'
    elsif @material.file_type == "pdf"
      render 'show_pdf'
    elsif @material.file_type == "uploaded_video"
      render 'show_uploaded_video'
    elsif @material.file_type == 'image'
      render 'show_image'
    else
      render 'show'
    end
  end

  # GET /materials/new
  def new
    
    @subjects = ["Matematicas" , "Biologia", "Quimica", "Fisica"]
    @Maths = File.read('clasifications/Math.json')
    @Schools = File.read('clasifications/Schools.json')
    @material = Material.new
  end

  # GET /materials/1/edit
  def edit
    @subjects = ["Matematicas" , "Biologia", "Quimica", "Fisica"]
    @Maths = File.read('clasifications/Math.json')
    @Schools = File.read('clasifications/Schools.json')
  end

  # POST /materials
  # POST /materials.json
  def create

    @material = Material.new(material_params)
    
    @material.tags = params[:material][:tags]
    @material.schools = params[:material][:schools]
    @material.user_id = current_user.id
    @material.uploadDate = DateTime.now
    # @material.username = current_user.username
    if params[:material][:format] == "file"
      @material.file = params[:material][:file]
      @material.authors = params[:material][:authors]
      if file_type != "unsupported_File"
        @material.file_type = file_type
      end
    else
      set_youtube_data()
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
    def set_youtube_data
      videoId = youtubeIdFrom(params[:material][:youtube_id])
      video = Yt::Video.new id: videoId
      @material.youtube_id = videoId
      @material.video_duration = video.duration
      # @material.thumbnail_url = video.thumbnail_url
      @material.authors = video.channel_title
      @material.youtubeChannel_id = video.channel_id
      channel = Yt::Channel.new id:  video.channel_id
      @material.youtubeChannel_avatar_url = channel.thumbnail_url
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def material_params

      params.require(:material).permit(:name, :description, :type, :format, :authors, :tags, :subject, :searchable, :schools)
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
          if file_type == "unsupported_File"
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
            when "application/vnd.openxmlformats-officedocument.presentationml.presentation","application/vnd.ms-powerpoint","application/vnd.ms-powerpoint.presentation.macroenabled.12","application/vnd.sun.xml.impress","application/vnd.sun.xml.impress.template","application/vnd.openxmlformats-officedocument.presentationml.slideshow","application/vnd.ms-powerpoint.presentation.macroenabled.12","application/vnd.oasis.opendocument.presentation","application/vnd.oasis.opendocument.presentation-template"
             return "slides"
            when "application/vnd.ms-excel","application/vnd.ms-excel.sheet.binary.macroenabled.12","application/vnd.ms-excel.sheet.macroenabled.12","application/vnd.openxmlformats-officedocument.spreadsheetml.sheet","application/vnd.sun.xml.calc","application/vnd.oasis.opendocument.spreadsheet"
              return "excel"
            when "application/x-rar-compressed","application/x-tar","application/x-7z-compressed","application/zip"
              return "compressed_File"
            when "video/mp4" , "video/ogg" , "video/webm"
              return "uploaded_video"
            
            else
              return "unsupported_File"
        end                
    end 


    
end