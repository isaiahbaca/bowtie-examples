Rails.application.routes.draw do
  resources :breweries, except: [:new, :edit] do
    resources :beers, except: [:new, :edit] do
      resources :ratings, except: [:new, :edit, :update, :destroy]
    end
  end
end
