class RentalsController < ApplicationController
  def index
    @rentals = Rental.all
  end

  def update
    @rental = Rental.find(params[:id])
    status = params[:status]

    begin
      case status
      when "rented"
        @rental.update!(status: "rented", rented_at: Time.current)
        flash[:success] = "#{@rental.id}番を貸出中にしました"
      when "returned"
        @rental.update!(status: "returned", returned_at: Time.current)
        flash[:success] = "#{@rental.id}番を返却済にしました"
      else
        flash[:error] = "無効なステータスです"
      end
    rescue => e
      Rails.logger.error "Rental update failed: #{e.message}"
      flash[:error] = "更新に失敗しました。もう一度お試しください。"
    end

    redirect_to rentals_path
  end
end
