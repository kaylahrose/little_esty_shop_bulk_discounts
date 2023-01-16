require 'rails_helper'

RSpec.describe 'merchants bulk discount show page' do
  # it '4: Merchant Bulk Discount Show

  # As a merchant
  # When I visit my bulk discount show page
  # Then I see the bulk discount's quantity threshold and percentage discount'
  it 'lists the discount quantity threshold and percentage discount' do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    bd1 = @merchant1.bulk_discounts.create!(percentage: 10, quantity_threshold: 10)
    bd2 = @merchant1.bulk_discounts.create!(percentage: 15, quantity_threshold: 15)

    visit merchant_bulk_discount_path(@merchant1, bd1)
    expect(page).to have_content(bd1.percentage)
    expect(page).to have_content(bd1.quantity_threshold)
    expect(page).to have_no_content(bd2.quantity_threshold)
  end
end