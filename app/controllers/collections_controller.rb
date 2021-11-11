# frozen_string_literal: true

class CollectionsController < AuthenticatedController
  def index
    custom_collections = ShopifyAPI::CustomCollection.find(:all, params: { limit: 10 })
    smart_collections = ShopifyAPI::SmartCollection.find(:all, params: { limit: 10 })
    render(json: { collections: (custom_collections + smart_collections).as_json })
  end

end
