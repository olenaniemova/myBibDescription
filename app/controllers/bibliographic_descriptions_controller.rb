class BibliographicDescriptionsController < ApplicationController
  before_action :set_bibliographic_description, only: [:show, :edit, :update, :destroy]

  # GET /bibliographic_descriptions
  # GET /bibliographic_descriptions.json
  def index
    @bibliographic_descriptions = BibliographicDescription.all
  end

  # GET /bibliographic_descriptions/1
  # GET /bibliographic_descriptions/1.json
  def show
  end

  # GET /bibliographic_descriptions/new
  def new
    @bibliographic_description = BibliographicDescription.new
  end

  # GET /bibliographic_descriptions/1/edit
  def edit
  end

  # POST /bibliographic_descriptions
  # POST /bibliographic_descriptions.json
  def create
    @bibliographic_description = BibliographicDescription.new(bibliographic_description_params)

    respond_to do |format|
      if @bibliographic_description.save
        format.html { redirect_to @bibliographic_description, notice: 'Bibliographic description was successfully created.' }
        format.json { render :show, status: :created, location: @bibliographic_description }
      else
        format.html { render :new }
        format.json { render json: @bibliographic_description.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bibliographic_descriptions/1
  # PATCH/PUT /bibliographic_descriptions/1.json
  def update
    respond_to do |format|
      if @bibliographic_description.update(bibliographic_description_params)
        format.html { redirect_to @bibliographic_description, notice: 'Bibliographic description was successfully updated.' }
        format.json { render :show, status: :ok, location: @bibliographic_description }
      else
        format.html { render :edit }
        format.json { render json: @bibliographic_description.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bibliographic_descriptions/1
  # DELETE /bibliographic_descriptions/1.json
  def destroy
    @bibliographic_description.destroy
    respond_to do |format|
      format.html { redirect_to bibliographic_descriptions_url, notice: 'Bibliographic description was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bibliographic_description
      @bibliographic_description = BibliographicDescription.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bibliographic_description_params
      params.require(:bibliographic_description).permit(:title, :description, :profile_id)
    end
end
