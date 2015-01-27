require 'rails_helper'

describe BeersController do
  let(:beer_params){
    {
      name: "test beer",
      description: "test description"
    }
  }

  let(:brewery) { create_brewery }
  let(:beer) { create_beer(brewery) }
  let(:author_headers) { { "X-Bowtie-User-Id" => beer.user_id } }
  let(:non_author_headers) { { "X-Bowtie-User-Id" => "bowtie_user_1" } }

  before do
    request.headers.merge!(author_headers)
  end

  describe "#index" do
    it "provides an index of all beers" do
      get :index, brewery_id: beer.brewery_id
      expect(response.status).to eq(200)
      expect(assigns[:beers]).to_not be(nil)
    end
  end

  describe "#show" do
    it "gives details about a beer" do
      get :show, brewery_id: brewery.id, id: beer.id
      expect(response.status).to eq(200)
      expect(assigns[:beer]).to eq(beer)
    end
  end

  describe "#create" do
    it "adds a beer" do
      expect{
        post :create, brewery_id: brewery.id, beer: beer_params
        expect(response.status).to eq(200)
      }.to change{Beer.count}
    end
  end

  describe "#update" do
    it "updates the beer" do
      post :update, brewery_id: brewery.id, id: beer.id, beer: { name: "updated name" }
      expect(response.status).to eq(200)

      beer.reload
      expect(beer.name).to eq("updated name")
    end

    it "denies updates to non-author" do
      request.headers.merge!(non_author_headers)

      expect {
        post :update, brewery_id: brewery.id, id: beer.id, beer: { name: "updated name" }
      }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end

  describe "#destroy" do
    it "removes a beer" do
      expect{
        post :destroy, brewery_id: brewery.id, id: beer.id
      }.to change{Beer.count}
    end

    it "doesn't remove a beer that author didn't create" do
      request.headers.merge!(non_author_headers)

      expect{
        post :destroy, brewery_id: brewery.id, id: beer.id
      }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
