class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @upcoming_holidays = blarg
  end
  
  def note 
      # make fetch request
      # parse fetch request
      # limit to next 3 top 3
      # only release name and date
      # helper self method
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
end
