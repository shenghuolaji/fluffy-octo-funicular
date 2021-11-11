module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :collections, String, null: false,
          description: "return collections"

    def collections
      # orderを取得してしてキャッシュに乗せておく
      fork do
        cached_monthly_orders
      end

      # collectionを取得
      collections = cached_collections

      JSON.generate(collections.as_json)
    end

    field :orders, String, null: false do
      description "return orders"
      argument :collection_id, String, required: true
    end

    def orders(collection_id:)
      # 指定されたcollection内のproduct一覧を取得する
      products = get_all_pages(ShopifyAPI::Product.where(collection_id: collection_id))
      product_ids = products.map(&:id)

      # 売上金を計算する関数
      def proceeds(orders, product_ids)
        orders.filter_map { |order|
          order.line_items.filter_map { |item|
            product_ids.include?(item.product_id) && item.fulfillment_status == "fulfilled" ? item.price.to_i * item.quantity : nil
          }.sum
        }.sum
      end

      # 売掛金を計算する関数
      def accounts_receivable(orders, product_ids)
        orders.filter_map { |order|
          order.line_items.filter_map { |item|
            product_ids.include?(item.product_id) && item.fulfillment_status != "fulfilled" ? item.price.to_i * item.quantity : nil
          }.sum
        }.sum
      end

      # orderの取得 (過去30日文)
      monthly_orders_all_products = cached_monthly_orders

      # 指定されたproductを含むorder
      monthly_orders = monthly_orders_all_products.filter do |order|
        order.line_items.map { |item|
          product_ids.include?(item.product_id)
        }.any?
      end

      # 日次のorder
      yesterday = Date.today.ago(1.days).to_time
      today_orders = monthly_orders.filter do |order|
        order.created_at > yesterday
      end

      result = {
        # 売掛金
        accountsReceivable: {
          daily: accounts_receivable(today_orders, product_ids),
          monthly: accounts_receivable(monthly_orders, product_ids)
        },
        # 売上金
        proceeds: {
          daily: proceeds(today_orders, product_ids),
          monthly: proceeds(monthly_orders, product_ids)
        }
      }

      JSON.generate((result))
    end

    private

    def get_all_pages(page)
      collection = page

      while page.next_page? do
        next_page = page.fetch_next_page

        collection = collection + next_page
        page = next_page
      end

      collection
    end

    def cached_collections
      Rails.cache.fetch("/collections", expired_in: 30.minute) do
        custom_collections = get_all_pages(ShopifyAPI::CustomCollection.find(:all))
        smart_collections = get_all_pages(ShopifyAPI::SmartCollection.find(:all))
        (custom_collections + smart_collections).to_a
      end
    end

    def cached_monthly_orders
      Rails.cache.fetch("/monthly_orders_all_products", expired_in: 30.minute) do
        # orderの取得 (過去30日分)
        get_all_pages(ShopifyAPI::Order.where(
          created_at_min: Date.today.ago(30.days).to_time.iso8601,
          status: "any",
          fields: "fulfillments, fulfillment_status, line_items, created_at"
        )).to_a
      end
    end
  end
end
