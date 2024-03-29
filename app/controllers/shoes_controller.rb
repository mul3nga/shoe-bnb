class ShoesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    # @shoes will be the shoes that the user can rent which have not been rented out.
    if current_user
      @shoes = Shoe.where(is_rented: false).reverse
      # @shoes = Shoe.all
    else
      @shoes = Shoe.all
    end

    if params[:query].present?
      sql_subquery = "name ILIKE :query OR brand ILIKE :query"
      @shoes = Shoe.where(sql_subquery, query: "%#{params[:query]}%")
      # raise
    end
  end

  def my_shoes
    # @my_shoes are the shoes that the user has created and can rent out.
    @my_shoes = Shoe.where("user_id = #{current_user.id}").reverse
  end

  def show
    @shoe = Shoe.find(params[:id])
    @booking = Booking.new
    @markers = { lat: @shoe.latitude, lng: @shoe.longitude }
  end

  def new
    @shoe = Shoe.new
  end

  def create
    @shoe = Shoe.new(shoe_params)
    @shoe.user = current_user
    if @shoe.save
      redirect_to my_shoes_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @shoe = Shoe.find(params[:id])
  end

  def update
    @shoe = Shoe.find(params[:id])
    @shoe.update(shoe_params)
    redirect_to my_shoes_path(@shoe)
  end

  def destroy
    @shoe = Shoe.find(params[:id])
    @shoe.destroy
    redirect_to my_shoes_path, status: :see_other
  end

  private

  def shoe_params
    params.require(:shoe).permit(:name, :brand, :price_per_day, :city,  photos: [])
  end
end
