require 'rails_helper'

RSpec.describe "bulk discounts index page" do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
  end
  #     1: Merchant Bulk Discounts Index

# As a merchant
# When I visit my merchant dashboard
# Then I see a link to view all my discounts
# When I click this link
# Then I am taken to my bulk discounts index page
# Where I see all of my bulk discounts including their
# percentage discount and quantity thresholds
# And each bulk discount listed includes a link to its show page

  it "lists all merchant's bulk discounts" do
    bd1 = @merchant1.bulk_discounts.create!(percentage: 10, quantity: 10)
    bd2 = @merchant1.bulk_discounts.create!(percentage: 15, quantity: 15)
    bd3 = @merchant1.bulk_discounts.create!(percentage: 30, quantity: 20)
    
    visit merchant_bulk_discounts_path(@merchant1)
    
    @merchant1.bulk_discounts.each do |bd|
      within("#discount-#{bd.id}") do
      expect(page).to have_content(bd.percentage)
      expect(page).to have_content(bd.quantity)
      click_link("Discount")
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, bd))
      visit merchant_bulk_discounts_path(@merchant1)
      end
    end
  end

  it "does not list other merchant's bulk discounts"
end