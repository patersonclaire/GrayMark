Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  get '/components', to: "pages#components"

  resources :schools, only: %i[index show new create] do
    resources :school_menus, only: %i[index new create]
  end

  resources :school_menus, only: %i[show] do
    resources :menus, only: %i[index show new create]
  end

  resources :menus, only: %i[] do
    resources :day_dishes, only: %i[index show]
  end

  resources :day_dishes, only: %i[] do
    resources :dish, only: %i[index show]
  end

  resources :profiles, except: %i[delete] do
    resources :profile_allergies, except: %i[delete]
  end

  resources :profile_allergies, only: %i[] do
    resources :ingredients, except: %i[delete]
  end

  resources :ingredients, only: %i[] do
    resources :dish_ingredients, only: %i[index show]
  end

  resources :dishes, only: %i[index show]
end

# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

# Defines the root path route ("/")
# root "articles#index"

# dish ingreditents should be via ingredients
# when listed first include 'only', when listed second include 'excepet'
