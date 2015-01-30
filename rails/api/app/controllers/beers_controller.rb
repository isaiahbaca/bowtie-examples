class BeersController < ApplicationController
  def index
    @brewery = Brewery.find(params[:brewery_id])
    @beers   = @brewery.beers

    render_json_success @beers
  end

  def show
    @brewery = Brewery.find(params[:brewery_id])
    @beer    = @brewery.beers.find(params[:id])

    render_json_success @beer
  end

  def create
    @brewery      = Brewery.find(params[:brewery_id])
    @beer         = @brewery.beers.new(beer_params)
    @beer.user_id = current_user_id

    if @beer.save
      render_json_success @beer
    else
      render_json_error t(:beer_save_failure), @beer.errors
    end
  end

  def update
    @brewery = Brewery.find(params[:brewery_id])
    @beer    = @brewery.beers.where(user_id: current_user_id).find(params[:id])

    if @beer.update_attributes(beer_params)
      render_json_success @beer
    else
      render_json_error t(:beer_save_failure), @beer.errors
    end
  end

  def destroy
    @brewery = Brewery.find(params[:brewery_id])
    @beer    = @brewery.beers.where(user_id: current_user_id).find(params[:id])

    if @beer.ratings.where('user_id != ?', current_user_id).count > 0
      render_json_error t(:beer_cannot_remove)
    else
      @beer.destroy
      render_json_success
    end
  end

  private
  def beer_params
    params.require(:beer).permit(:name, :description)
  end
end
