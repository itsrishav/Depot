class Product < ActiveRecord::Base
	has_many :line_items
	before_destroy :ensure_not_reference_to_any_line_item
	validates :title, uniqueness: true, presence: true
	validates :description, presence: true
	validates :image_url, format:{
		with: %r{.(jpg|gif|png)\Z}i,
		message: "must be a URL for GIF, JPG or PNG image."
	}
	validates :price, numericality: {greater_than_or_equal_to: 0.01}
	def self.cached_latest
		Rails.cache.fetch([self.name, 'latest']) {self.order(:updated_at).last}
	end

	def self.cached_order_title
		Rails.cache.fetch([self.name, 'order_title']) { self.order(:title).to_a }
	end

	def self.cached_find(id)
		Rails.cache.fetch([self.name, id]) { self.find(id)}
	end

	def self.cached_all
		Rails.cache.fetch([self.name, 'all']) {self.all.to_a}
	end

	def flush_cache
		Rails.cache.delete([self.class.name, id])
		Rails.cache.delete([self.name, 'order_title'])
		Rails.cache.delete([self.class.name, 'all'])
	end

private
	def ensure_not_referenced_by_any_line_item
		if line_items.empty?
			return true
		else
			errors.add(:base, 'Line Items present')
			return false
		end
	end
end
