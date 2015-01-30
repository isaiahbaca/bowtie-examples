class BeersController < ApplicationController
  def index
    @brewery = Brewery.find(params[:brewery_id])
    @beers   = @brewery.beers

    respond_to do |format|
      format.json { render_json_success @beers }
      format.html { }
    end
  end

  def show
    @brewery = Brewery.find(params[:brewery_id])
    @beer    = @brewery.beers.find(params[:id])

    respond_to do |format|
      format.json { render_json_success @beer }
      format.html {
        @ratings = @beer.ratings
        @rating  = @beer.ratings.new
      }
    end
  end

  def new
    @brewery = Brewery.find(params[:brewery_id])
    @beer    = @brewery.beers.new

    respond_to do |format|
      format.html { }
    end
  end

  def create
    @brewery      = Brewery.find(params[:brewery_id])
    @beer         = @brewery.beers.new(beer_params)
    @beer.user_id = current_user_id

    respond_to do |format|
      if @beer.save
        format.json { render_json_success @beer }
        format.html { redirect_to brewery_beer_path(@brewery, @beer) }
      else
        format.json { render_json_error t(:beer_save_failure), @beer.errors }
        format.html { }
      end
    end
  end

  def edit
    @brewery = Brewery.find(params[:brewery_id])
    @beer    = @brewery.beers.find(params[:id])

    respond_to do |format|
      format.html { }
    end
  end

  def update
    @brewery = Brewery.find(params[:brewery_id])
    @beer    = @brewery.beers.where(user_id: current_user_id).find(params[:id])

    respond_to do |format|
      if @beer.update_attributes(beer_params)
        format.json { render_json_success @beer }
        format.html { redirect_to brewery_beer_path(@brewery, @beer) }
      else
        format.json { render_json_error t(:beer_save_failure), @beer.errors }
        format.html { render 'edit' }
      end
    end
  end

  def destroy
    @brewery = Brewery.find(params[:brewery_id])
    @beer    = @brewery.beers.where(user_id: current_user_id).find(params[:id])

    respond_to do |format|
      if @beer.ratings.where('user_id != ?', current_user_id).count > 0
        format.json { render_json_error t(:beer_cannot_remove) }
        format.html { redirect_to brewery_beer_path(@brewery, @beer), alert: t(:beer_cannot_remove) }
      else
        @beer.destroy
        format.json { render_json_success }
        format.html { redirect_to brewery_beers_path(@brewery), notice: t(:beer_remove_success) }
      end
    end
  end

  private
  def beer_params
    params.require(:beer).permit(:name, :description)
  end
end
