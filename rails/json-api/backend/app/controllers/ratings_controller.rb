class RatingsController < ApplicationController
  def index
    @ratings = beer.ratings.order('created_at desc')
    render_json_success @ratings
  end

  def create
    @rating = beer.ratings.new rating_params

    if @rating.save
      render_json_success @rating
    else
      render_json_error t(:rating_save_failure), @rating.errors
    end
  end

  private
  def rating_params
    params.require(:rating).permit(:comment, :rating)
  end

  def brewery
    Brewery.find(params[:brewery_id])
  end

  def beer
    brewery.beers.find(params[:beer_id])
  end
end
