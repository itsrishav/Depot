class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :cart
  def total_price
		product.price * quantity
	end

	def self.cached_find(id)
		Rails.cache.fetch([self.name, id]) { self.find(id)}
	end

	def self.cached_all
		Rails.cache.fetch([self.name, 'all']) {self.all}
	end

	def cached_product
		Rails.cache.fetch([self, id]) {self.product}
	end

	def flush_cache
		Rails.cache.delete([self.class.name, id])
		Rails.cache.delete([self.class.name, 'all'])
		cart.flush_cache
	end

end
