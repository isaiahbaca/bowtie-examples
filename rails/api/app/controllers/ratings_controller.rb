class RatingsController < ApplicationController
  def index
    @ratings = beer.ratings.order('created_at desc')

    respond_to do |format|
      format.json { render_json_success @ratings }
    end
  end

  def create
    @beer    = beer
    @brewery = brewery
    @rating  = beer.ratings.new rating_params

    respond_to do |format|
      if @rating.save
        format.json { render_json_success @rating }
        format.html { redirect_to brewery_beer_path(@brewery, @beer), notice: t(:rating_create_success) }
      else
        format.json { render_json_error t(:rating_save_failure), @rating.errors }
        format.html { }
      end
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
