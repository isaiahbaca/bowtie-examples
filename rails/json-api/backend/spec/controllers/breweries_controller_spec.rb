require 'rails_helper'

describe BreweriesController do
  let(:brewery_params){
    {
      name:         "test brewery",
      description:  "test description",
      city:         "Albuquerque",
      state:        "New Mexico",
      country:      "United States",
      user_id:      "bowtie_user_0"
    }
  }

  let(:brewery) { create_brewery }
  let(:author_headers) { { "X-Bowtie-User-Id" => brewery.user_id } }
  let(:non_author_headers) { { "X-Bowtie-User-Id" => "bowtie_user_1" } }

  before do
    request.headers.merge!(author_headers)
  end

  describe "#index" do
    it "provides an index of all breweries" do
      brewery = create_brewery
      get :index
      expect(response.status).to eq(200)
      expect(assigns[:breweries]).to include(brewery)
    end
  end

  describe "#show" do
    it "gives details about a brewery" do
      get :show, id: brewery.id
      expect(response.status).to eq(200)
      expect(assigns[:brewery]).to eq(brewery)
    end
  end

  describe "#create" do
    it "adds a brewery" do
      expect{
        post :create, brewery: brewery_params
        expect(response.status).to eq(200)
      }.to change{Brewery.count}
    end
  end

  describe "#update" do
    it "updates the brewery" do
      post :update, id: brewery.id, brewery: { name: "updated name" }
      expect(response.status).to eq(200)

      brewery.reload
      expect(brewery.name).to eq("updated name")
    end

    it "denies updates to non-author" do
      request.headers.merge!(non_author_headers)

      expect {
        post :update, id: brewery.id, brewery: { name: "updated name" }
      }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end

  describe "#destroy" do
    it "removes a brewery" do
      expect{
        post :destroy, id: brewery.id
      }.to change{Brewery.count}
    end

    it "doesn't remove a brewery that others contributed to" do
      request.headers.merge!(non_author_headers)

      expect{
        post :destroy, id: brewery.id
      }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
