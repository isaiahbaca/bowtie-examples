class BreweriesController < ApplicationController
  def index
    @breweries = Brewery.all

    respond_to do |format|
      format.json { render_json_success @breweries }
      format.html { }
    end
  end

  def show
    @brewery = Brewery.find params[:id]
    @beers = @brewery.beers

    respond_to do |format|
      format.json { render_json_success @brewery }
      format.html { }
    end
  end

  def new
    @brewery = Brewery.new
    @brewery.user_id = current_user_id

    respond_to do |format|
      format.json { head 422 }
      format.html { }
    end
  end

  def create
    @brewery = Brewery.new brewery_params
    @brewery.user_id = current_user_id

    respond_to do |format|
      if @brewery.save
        format.json { render_json_success @brewery }
        format.html { redirect_to brewery_path(@brewery), notice: t(:brewery_create_success) }
      else
        format.json { render_json_error t(:brewery_create_failure), @brewery.errors }
        format.html { }
      end
    end
  end

  def edit
    @brewery = Brewery.where(user_id: current_user_id).find(params[:id])

    respond_to do |format|
      format.json { head 422 }
      format.html { }
    end
  end

  def update
    @brewery = Brewery.where(user_id: current_user_id).find(params[:id])

    respond_to do |format|
      if @brewery.update_attributes(brewery_params)
        format.json { render_json_success @brewery }
        format.html { redirect_to brewery_path(@brewery), notice: t(:brewery_update_success) }
      else
        format.json { render_json_error t(:brewery_update_failure), @brewery.errors }
        format.html { }
      end
    end
  end

  def destroy
    @brewery = Brewery.where(user_id: current_user_id).find(params[:id])

    respond_to do |format|
      if @brewery.beers.where('user_id != ?', current_user_id).count > 0
        format.json { render_json_error t(:brewery_destroy_failure) }
        format.html { redirect_to '/users/sign_in', notice: t(:brewery_destroy_failure) }
      else
        @brewery.destroy
        format.json { render_json_success }
        format.html { redirect_to breweries_path, notice: t(:brewery_destroy_success) }
      end
    end
  end

  private
  def brewery_params
    params.require(:brewery).permit(:name,
                                    :description,
                                    :city,
                                    :state,
                                    :country)
  end
end
