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
	def self.latest
		Product.order(:updated_at).last
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
