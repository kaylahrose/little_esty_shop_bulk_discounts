require 'rails_helper'

RSpec.describe "bulk discounts index page" do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
  end

  it "lists all merchant's bulk discounts" do
    bd1 = @merchant1.bulk_discounts.create!(percentage: 10, quantity_threshold: 10)
    bd2 = @merchant1.bulk_discounts.create!(percentage: 15, quantity_threshold: 15)
    bd3 = @merchant1.bulk_discounts.create!(percentage: 30, quantity_threshold: 20)
    
    visit merchant_bulk_discounts_path(@merchant1)
    
    @merchant1.bulk_discounts.each do |bd|
      within("#discount-#{bd.id}") do
        expect(page).to have_content(bd.percentage)
        expect(page).to have_content(bd.quantity_threshold)
        click_link("Discount")
        expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, bd))
        visit merchant_bulk_discounts_path(@merchant1)
      end
    end
  end

  it "does not list other merchant's bulk discounts"

  it "has a link to create a new discount" do
    visit merchant_bulk_discounts_path(@merchant1)

    click_link "Create New Discount"
    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))
    fill_in "Percentage", with: 50
    fill_in "Quantity", with: 50
    click_button "Submit"
  
    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
    bd = BulkDiscount.last
  
    within("#discount-#{bd.id}") do
      expect(page).to have_content(bd.percentage)
    end
  end

  it 'deletes discount' do
    bd1 = @merchant1.bulk_discounts.create!(percentage: 10, quantity_threshold: 10)
    bd2 = @merchant1.bulk_discounts.create!(percentage: 15, quantity_threshold: 15)
    bd3 = @merchant1.bulk_discounts.create!(percentage: 30, quantity_threshold: 20)
    
    visit merchant_bulk_discounts_path(@merchant1)
    expect(page).to have_content(bd1.percentage)
    expect(page).to have_content(bd1.quantity_threshold)
    within("#discount-#{bd.id}") do
    click_link("Delete")
  end
  
    expect(page).to have_no_content(bd1.percentage)
    expect(page).to have_no_content(bd1.quantity_threshold)
    expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, bd))
  end
end