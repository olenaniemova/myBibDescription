class BibliographicStylesController < ApplicationController
  before_action :set_bibliographic_style, only: [:show, :edit, :update, :destroy]

  # GET /bibliographic_styles
  # GET /bibliographic_styles.json
  def index
    # @bibliographic_styles = BibliographicStyle.all
    render :index
  end

  # GET /bibliographic_styles/1
  # GET /bibliographic_styles/1.json
  def show
  end

  # GET /bibliographic_styles/new
  def new
    @bibliographic_style = BibliographicStyle.new
  end

  # GET /bibliographic_styles/1/edit
  def edit
  end

  # POST /bibliographic_styles
  # POST /bibliographic_styles.json
  def create
    @bibliographic_style = BibliographicStyle.new(bibliographic_style_params)

    respond_to do |format|
      if @bibliographic_style.save
        format.html { redirect_to @bibliographic_style, notice: 'Bibliographic style was successfully created.' }
        format.json { render :show, status: :created, location: @bibliographic_style }
      else
        format.html { render :new }
        format.json { render json: @bibliographic_style.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bibliographic_styles/1
  # PATCH/PUT /bibliographic_styles/1.json
  def update
    respond_to do |format|
      if @bibliographic_style.update(bibliographic_style_params)
        format.html { redirect_to @bibliographic_style, notice: 'Bibliographic style was successfully updated.' }
        format.json { render :show, status: :ok, location: @bibliographic_style }
      else
        format.html { render :edit }
        format.json { render json: @bibliographic_style.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bibliographic_styles/1
  # DELETE /bibliographic_styles/1.json
  def destroy
    @bibliographic_style.destroy
    respond_to do |format|
      format.html { redirect_to bibliographic_styles_url, notice: 'Bibliographic style was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def apa
    respond_to do |format|
      format.html { render :apa }
    end
  end

  def mla
    respond_to do |format|
      format.html { render :mla }
    end
  end

  def harvard
    respond_to do |format|
      format.html { render :harvard }
    end
  end

  def chicago
    respond_to do |format|
      format.html { render :chicago }
    end
  end

  def dstu
    respond_to do |format|
      format.html { render :dstu }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bibliographic_style
      @bibliographic_style = BibliographicStyle.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bibliographic_style_params
      params.require(:bibliographic_style).permit(:title, :description)
    end
end
