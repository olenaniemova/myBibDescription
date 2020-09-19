class SourceStylesController < ApplicationController
  before_action :set_source_style, only: [:show, :edit, :update, :destroy]

  # GET /source_styles
  # GET /source_styles.json
  def index
    @source_styles = SourceStyle.all
  end

  # GET /source_styles/1
  # GET /source_styles/1.json
  def show
  end

  # GET /source_styles/new
  def new
    @source_style = SourceStyle.new
  end

  # GET /source_styles/1/edit
  def edit
  end

  # POST /source_styles
  # POST /source_styles.json
  def create
    @source_style = SourceStyle.new(source_style_params)

    respond_to do |format|
      if @source_style.save
        format.html { redirect_to @source_style, notice: 'Source style was successfully created.' }
        format.json { render :show, status: :created, location: @source_style }
      else
        format.html { render :new }
        format.json { render json: @source_style.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /source_styles/1
  # PATCH/PUT /source_styles/1.json
  def update
    respond_to do |format|
      if @source_style.update(source_style_params)
        format.html { redirect_to @source_style, notice: 'Source style was successfully updated.' }
        format.json { render :show, status: :ok, location: @source_style }
      else
        format.html { render :edit }
        format.json { render json: @source_style.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /source_styles/1
  # DELETE /source_styles/1.json
  def destroy
    @source_style.destroy
    respond_to do |format|
      format.html { redirect_to source_styles_url, notice: 'Source style was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_source_style
      @source_style = SourceStyle.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def source_style_params
      params.require(:source_style).permit(:title, :description, :schema, :source_id, :bibliographic_style_id)
    end
end
