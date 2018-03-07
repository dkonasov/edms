Rails.application.routes.draw do
  scope ':model_name', controller: 'api' do
    get '/', action: 'index'
    get '/:id', action: 'show'
    post '/', action: 'create'
    put '/:id', action: 'update'
    delete '/:id', action: 'destroy'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
