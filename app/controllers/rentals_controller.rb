require "net/http"
require "json"

class RentalsController < ApplicationController
  def index
    @rentals = Rental.all
  end

  def update
    @rental = Rental.find(params[:id])
    status = params[:status]

    begin
      case status
      when "requested"
        @rental.update!(status: "requested", requested_at: Time.current)
        flash[:success] = "#{@rental.id}番を申請中にしました"
      when "rented"
        @rental.update!(status: "rented", rented_at: Time.current)
        # LINEにメッセージ送信
        send_push_message(@rental.line_user_id, "利用ありがとうございます！試合終了後、ユニフォームを本ブースまで返却ください。準備は揃いました。精一杯応援して勝ちましょう！！")
        flash[:success] = "#{@rental.id}番を貸出中にしました（LINEメッセージ送信済み）"
      when "returned"
        @rental.update!(status: "returned", returned_at: Time.current)
        # LINEにメッセージ送信
        send_push_message(@rental.line_user_id, "ご利用ありがとうございました。またのご利用お待ちしております！")
        flash[:success] = "#{@rental.id}番を返却済にしました（LINEメッセージ送信済み）"
      else
        flash[:error] = "無効なステータスです"
      end
    rescue => e
      Rails.logger.error "Rental update failed: #{e.message}"
      flash[:error] = "更新に失敗しました。もう一度お試しください。"
    end

    redirect_to rentals_path
  end

  private

  def send_push_message(user_id, message)
    return unless user_id

    line_api_url = "https://api.line.me/v2/bot/message/push"
    headers = {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV['LINE_CHANNEL_ACCESS_TOKEN']}"
    }
    
    body = {
      to: user_id,
      messages: [{
        type: "text",
        text: message
      }]
    }.to_json

    response = Net::HTTP.post(URI(line_api_url), body, headers)
    
    if response.code == "200"
      Rails.logger.info "LINE push message sent successfully to #{user_id}: #{message}"
    else
      Rails.logger.error "LINE push message failed: #{response.code} #{response.body}"
    end
  rescue => e
    Rails.logger.error "LINE push message error: #{e.message}"
  end
end
