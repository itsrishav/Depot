class Cart < ActiveRecord::Base
	has_many :line_items, dependent: :destroy
	after_commit :flush_cache

	def add_product(product_id)
		current_item = line_items.find_by(product_id: product_id)
		if current_item
			current_item.quantity += 1
		else
			current_item = line_items.build(product_id: product_id)
		end
		current_item
	end
	def total_price
		line_items.to_a.sum { |item| item.total_price }
	end

	def self.cached_find(id)
		Rails.cache.fetch([self.name, id]) { self.find(id)}
	end

	def self.cached_all
		Rails.cache.fetch([self.name, 'all']) {self.all}
	end

	def cached_line_items
		Rails.cache.fetch([self, 'line_items']){line_items}
	end

	def flush_cache
		Rails.cache.delete([self.class.name, id])
		Rails.cache.delete([self.class.name, 'all'])
		Rails.cache.delete([self, 'line_items'])
	end

end
