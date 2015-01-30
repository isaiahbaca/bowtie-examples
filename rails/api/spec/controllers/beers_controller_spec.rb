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
    context "format: supported" do
      it "provides an index of all beers" do
        get :index, brewery_id: beer.brewery_id
        expect(assigns[:beers]).to_not be(nil)
      end
    end

    context "format: `json`" do
      it "provides an index of all beers" do
        get :index, brewery_id: beer.brewery_id, format: :json
        expect(response.status).to eq(200)
      end
    end

    context "format: `html`" do
      render_views

      it "provides an index of all beers" do
        get :index, brewery_id: beer.brewery_id
        expect(response.status).to eq(200)
      end
    end
  end

  describe "#show" do
    context "format: supported" do
      it "gives details about a beer" do
        get :show, brewery_id: brewery.id, id: beer.id
        expect(response.status).to eq(200)
        expect(assigns[:beer]).to eq(beer)
      end
    end

    context "format: `json`" do
      it "provides a JSON formatted details page" do
        get :show, brewery_id: brewery.id, id: beer.id, format: :json
        expect(response.status).to eq(200)
      end
    end

    context "format: `html`" do
      render_views

      it "provides an HTML formatted details page" do
        get :show, brewery_id: brewery.id, id: beer.id
        expect(subject).to render_template('beers/show')
      end
    end
  end

  describe "#new" do
    context "format: `json`" do
      it "throws an unknown format error" do
        expect {
          get :new, brewery_id: brewery.id, format: :json
        }.to raise_exception(ActionController::UnknownFormat)
      end
    end

    context "format: `html`" do
      render_views

      it "renders a form for creating a new beer" do
        get :new, brewery_id: brewery.id
        expect(subject).to render_template('beers/new')
      end
    end
  end

  describe "#create" do
    context "format: supported" do
      it "adds a beer" do
        expect{
          post :create, brewery_id: brewery.id, beer: beer_params
        }.to change{Beer.count}
      end
    end

    context "format: `json`" do
      it "provides a JSON formatted success response" do
        post :create, brewery_id: brewery.id, beer: beer_params, format: :json
        expect(response.status).to eq(200)
        expect(response).to be_json
      end
    end

    context "format: `html`" do
      it "redirects to the new beer's detail page" do
        post :create, brewery_id: brewery.id, beer: beer_params
        expect(subject).to redirect_to(brewery_beer_path(brewery, assigns[:beer]))
      end
    end
  end

  describe "#edit" do
    context "format: `json'" do
      it "throws an unknown format error" do
        expect {
          get :edit, brewery_id: brewery.id, id: beer.id, format: :json
        }.to raise_exception(ActionController::UnknownFormat)
      end
    end

    context "format: `html`" do
      render_views

      it "renders a form for editing an existing beer"
      it "disallows edits for a beer not authored by current user"
    end
  end

  describe "#update" do
    context "format: supported" do
      it "updates the beer" do
        post :update, brewery_id: brewery.id, id: beer.id, beer: { name: "updated name" }

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

    context "format: `json`" do
      it "provides a JSON formatted success response" do
        post :update, brewery_id: brewery.id, id: beer.id, beer: { name: "updated name" }, format: :json
        expect(response.status).to eq(200)
        expect(response).to be_json
      end

      it "provides a JSON formatted error response" do
        expect_any_instance_of(Beer).to receive(:update_attributes).and_return(false)
        post :update, brewery_id: brewery.id, id: beer.id, beer: { name: "updated name" }, format: :json
        expect(response).to be_json
      end
    end

    context "format: `html`" do
      render_views

      it "redirects back to the beer detail page after success" do
        post :update, brewery_id: brewery.id, id: beer.id, beer: { name: "updated name" }
        expect(subject).to redirect_to(brewery_beer_path(brewery, beer))
      end

      it "renders the 'new' template on failure" do
        expect_any_instance_of(Beer).to receive(:update_attributes).and_return(false)
        post :update, brewery_id: brewery.id, id: beer.id, beer: { name: "updated name" }
        expect(subject).to render_template('beers/edit')
      end
    end
  end

  describe "#destroy" do
    context "format: supported" do
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

    context "format: `json`" do
      it "provides a JSON formatted success response"
      it "provides a JSON formatted error response"
    end

    context "format: `html`" do
      it "redirects to the brewery's beer index on success"
      it "provides an HTML formatted error response"
    end
  end
end
