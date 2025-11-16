class RentalsController < ApplicationController
  def index
    @rentals = Rental.all
  end

  def update
    @rental = Rental.find(params[:id])
    status = params[:status]
    
    case status
    when 'rented'
      @rental.update!(status: 'rented', rented_at: Time.current)
    when 'returned'
      @rental.update!(status: 'returned', returned_at: Time.current)
    end
    
    redirect_to rentals_path, notice: "Status updated successfully"
  end
end
