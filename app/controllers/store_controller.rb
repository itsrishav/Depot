class StoreController < ApplicationController
  include CurrentCart
  before_action :set_cart
  def index
  	@products = Product.cached_order_title
  end
end
