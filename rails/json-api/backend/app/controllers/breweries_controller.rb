class BreweriesController < ApplicationController
  def index
    @breweries = Brewery.all
    render_json_success @breweries
  end

  def show
    @brewery = Brewery.find params[:id]
    render_json_success @brewery
  end

  def create
    @brewery = Brewery.new brewery_params
    @brewery.user_id = current_user_id

    if @brewery.save
      render_json_success @brewery
    else
      render_json_error t(:brewery_save_failure), @brewery.errors
    end
  end

  def update
    @brewery = Brewery.where(user_id: current_user_id).find(params[:id])

    if @brewery.update_attributes(brewery_params)
      render_json_success @brewery
    else
      render_json_error t(:brewery_save_failure), @brewery.errors
    end
  end

  def destroy
    @brewery = Brewery.where(user_id: current_user_id).find(params[:id])

    if @brewery.beers.where('user_id != ?', current_user_id).count > 0
      render_json_error t(:brewery_cannot_remove)
    else
      @brewery.destroy
      render_json_success
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
