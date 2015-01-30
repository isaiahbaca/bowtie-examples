require 'rails_helper'

describe RatingsController do
  let(:rating_params){
    { comment:  "test comment",
      rating:   10 }
  }

  let(:brewery){ create_brewery }
  let(:beer){ create_beer(brewery) }
  let(:rating) { create_rating(beer) }
  let(:author_headers) { { "X-Bowtie-User-Id" => rating.user_id } }
  let(:non_author_headers) { { "X-Bowtie-User-Id" => "bowtie_user_1" } }

  before do
    request.headers.merge!(author_headers)
  end

  describe "#index" do
    context "format: supported" do
      it "provides an index of all ratings" do
        create_rating(beer)
        get :index, brewery_id: brewery.id, beer_id: beer.id, format: :json
        expect(assigns[:ratings]).to include(rating)
      end
    end

    context "format: `json`" do
      it "provides a JSON response" do
        create_rating(beer)
        get :index, brewery_id: brewery.id, beer_id: beer.id, format: :json
        expect(response).to be_json
      end
    end

    context "format: `html`" do
      it "throws an unknown format error" do
        expect {
          get :index, brewery_id: brewery.id, beer_id: beer.id
        }.to raise_exception(ActionController::UnknownFormat)
      end
    end
  end

  describe "#create" do
    context "format: supported" do
      it "adds a new rating" do
        expect{
          post :create, brewery_id: brewery.id, beer_id: beer.id, rating: rating_params
        }.to change{Rating.count}
      end
    end

    context "format: `json`" do
      it "responds with JSON" do
        post :create, brewery_id: brewery.id, beer_id: beer.id, rating: rating_params, format: :json
        expect(response).to be_json
      end
    end

    context "format: `html`" do
      it "redirects to the beer detail page" do
        post :create, brewery_id: brewery.id, beer_id: beer.id, rating: rating_params
        expect(subject).to redirect_to(brewery_beer_path(brewery, beer))
      end
    end
  end
end
