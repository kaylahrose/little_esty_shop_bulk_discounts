class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant
  # scope :bulk_discount, -> { joins(:bulk_discounts).where("quantity >= bulk_discounts.quantity_threshold").order("bulk_discounts.percentage DESC") }

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def best_discount
    bulk_discounts.where("quantity_threshold <= ?", quantity).order(percentage: :desc).first
  end

  def revenue
  end

  def revenue_with_discount
  end
end
