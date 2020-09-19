class BibliographicDescriptionItemsController < ApplicationController
  before_action :set_bibliographic_description_item, only: [:show, :edit, :update, :destroy]

  # GET /bibliographic_description_items
  # GET /bibliographic_description_items.json
  def index
    @bibliographic_description_items = BibliographicDescriptionItem.all
  end

  # GET /bibliographic_description_items/1
  # GET /bibliographic_description_items/1.json
  def show
  end

  # GET /bibliographic_description_items/new
  def new
    @bibliographic_description_item = BibliographicDescriptionItem.new
  end

  # GET /bibliographic_description_items/1/edit
  def edit
  end

  # POST /bibliographic_description_items
  # POST /bibliographic_description_items.json
  def create
    @bibliographic_description_item = BibliographicDescriptionItem.new(bibliographic_description_item_params)

    respond_to do |format|
      if @bibliographic_description_item.save
        format.html { redirect_to @bibliographic_description_item, notice: 'Bibliographic description item was successfully created.' }
        format.json { render :show, status: :created, location: @bibliographic_description_item }
      else
        format.html { render :new }
        format.json { render json: @bibliographic_description_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bibliographic_description_items/1
  # PATCH/PUT /bibliographic_description_items/1.json
  def update
    respond_to do |format|
      if @bibliographic_description_item.update(bibliographic_description_item_params)
        format.html { redirect_to @bibliographic_description_item, notice: 'Bibliographic description item was successfully updated.' }
        format.json { render :show, status: :ok, location: @bibliographic_description_item }
      else
        format.html { render :edit }
        format.json { render json: @bibliographic_description_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bibliographic_description_items/1
  # DELETE /bibliographic_description_items/1.json
  def destroy
    @bibliographic_description_item.destroy
    respond_to do |format|
      format.html { redirect_to bibliographic_description_items_url, notice: 'Bibliographic description item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bibliographic_description_item
      @bibliographic_description_item = BibliographicDescriptionItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bibliographic_description_item_params
      params.require(:bibliographic_description_item).permit(:title, :year, :publisher, :source_style_id)
    end
end
