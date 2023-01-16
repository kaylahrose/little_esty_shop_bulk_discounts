require 'rails_helper'

RSpec.describe 'merchants bulk discount show page' do
  it 'lists the discount quantity threshold and percentage discount' do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    bd1 = @merchant1.bulk_discounts.create!(percentage: 10, quantity_threshold: 10)
    bd2 = @merchant1.bulk_discounts.create!(percentage: 15, quantity_threshold: 15)

    visit merchant_bulk_discount_path(@merchant1, bd1)
    expect(page).to have_content(bd1.percentage)
    expect(page).to have_content(bd1.quantity_threshold)
    expect(page).to have_no_content(bd2.quantity_threshold)
  end

#   5: Merchant Bulk Discount Edit

# As a merchant
# When I visit my bulk discount show page
# Then I see a link to edit the bulk discount
# When I click this link
# Then I am taken to a new page with a form to edit the discount
# And I see that the discounts current attributes are pre-poluated in the form
# When I change any/all of the information and click submit
# Then I am redirected to the bulk discount's show page
# And I see that the discount's attributes have been updated
  it 'edits merchant bulk discount object' do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    bd1 = @merchant1.bulk_discounts.create!(percentage: 10, quantity_threshold: 10)

    
    visit merchant_bulk_discount_path(@merchant1, bd1)
    click_link "Edit"
    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1, bd1))
    expect(page).to have_no_content(15)

    fill_in 'Percentage', with: 15
    click_button 'Submit'

    expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, bd1))
    expect(page).to have_content(15)
  end

end