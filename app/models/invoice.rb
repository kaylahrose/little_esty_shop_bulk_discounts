class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: [:cancelled, 'in progress', :completed]

  def total_revenue
    invoice_items.sum(&:revenue)
  end

  def total_revenue_for_merchant(merchant)
    merchant.invoice_items.where(invoice: self).sum(&:revenue)
  end

  def discounted_revenue_for_merchant(merchant)
    sum_of_revenue_from_invoice_items
  end
end
