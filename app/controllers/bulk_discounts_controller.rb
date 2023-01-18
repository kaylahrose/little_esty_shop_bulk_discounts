class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @holidays = get_holidays

  end

  def get_data
    response = HTTParty.get(@url)
    JSON.parse(response.body, symbolize_names: true)
  end
  
  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end
  
  def new
    @merchant = Merchant.find(params[:merchant_id])
  end
  
  def create
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.bulk_discounts.create(discount_params)
    redirect_to merchant_bulk_discounts_path(@merchant)
  end
  
  def edit
    @discount = BulkDiscount.find(params[:id])
  end
  
  def update
    @discount = BulkDiscount.find(params[:id])
    @discount.update(discount_params)    
    redirect_to merchant_bulk_discount_path(@discount.merchant, @discount)
  end
  
  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    discount = BulkDiscount.find(params[:id])
    discount.destroy
    redirect_to merchant_bulk_discounts_path(@merchant)
  end


  private
    def discount_params
      params.require(:bulk_discount).permit(:percentage, :quantity_threshold)
    end

      def get_holidays
    url = "https://date.nager.at/api/v3/NextPublicHolidays/US"
    response = HTTParty.get(url)
    data = JSON.parse(response.body, symbolize_names: true)
    holiday_data = data.take(3)
    holidays = {}
    holiday_data.each do |holiday|
      holidays[holiday[:name].to_sym] = holiday[:date]
    end
  end
end
