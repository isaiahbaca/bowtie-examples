Rails.application.routes.draw do
  resources :breweries do
    resources :beers do
      resources :ratings, except: [:new, :edit, :update, :destroy]
    end
  end

  root 'breweries#index'
end
