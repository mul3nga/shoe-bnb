class BookingsController < ApplicationController
  def index
    @bookings = Booking.where("user_id = #{current_user.id}")
  end

  def new
    @booking = Booking.new
    @shoe = Shoe.find(params[:shoe_id])
  end

  def create
    @shoe = Shoe.find(params[:shoe_id])
    @booking = Booking.new(booking_params)
    @booking.shoe = @shoe
    @shoe.is_rented = true
    @booking.user = current_user

    if @booking.save && @shoe.save
      redirect_to bookings_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @booking = Booking.find(params[:id])

    @shoe = @booking.shoe
    @shoe.is_rented = false
    @shoe.save

    @booking.destroy
    redirect_to bookings_path, status: :see_other
  end

  private

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :shoe_id)
  end
end
