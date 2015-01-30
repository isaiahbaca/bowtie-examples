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
    it "provides an index of all ratings" do
      create_rating(beer)

      get :index, brewery_id: brewery.id, beer_id: beer.id

      expect(response.status).to eq(200)
      expect(assigns[:ratings]).to include(rating)
    end
  end

  describe "#create" do
    it "adds a rating" do
      expect{
        post :create, brewery_id: brewery.id, beer_id: beer.id, rating: rating_params
        expect(response.status).to eq(200)
      }.to change{Rating.count}
    end
  end
end
