# app/controllers/order_items_controller.rb
class OrderItemsController < ApplicationController
  before_action :set_order
  before_action :set_order_item, only: [:show, :edit, :update, :destroy]

  def index
    @order_items = @order.order_items
  end

  def show
  end

  def new
    @order_item = @order.order_items.build
  end

  def create
    @order_item = @order.order_items.build(order_item_params)
    if @order_item.save
      redirect_to order_order_items_path(@order), notice: 'Order item was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @order_item.update(order_item_params)
      redirect_to order_order_items_path(@order), notice: 'Order item was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @order_item.destroy
    redirect_to order_order_items_path(@order), notice: 'Order item was successfully destroyed.'
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def set_order_item
    @order_item = @order.order_items.find(params[:id])
  end

  def order_item_params
    params.require(:order_item).permit(:product_name, :quantity, :price)
  end
end
