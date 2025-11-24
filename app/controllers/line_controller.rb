require "net/http"
require "json"

class LineController < ApplicationController
  protect_from_forgery except: :webhook

  def webhook
    body = request.body.read
    Rails.logger.info "LINE Webhook received: #{body}"
    
    events = JSON.parse(body)["events"]
    
    events.each do |event|
      next unless event["type"] == "message" && event["message"]["type"] == "text"
      
      message_text = event["message"]["text"]
      user_id = event["source"]["userId"]
      reply_token = event["replyToken"]
      
      if message_text == "レンタル"
        # レンタル申請レコード作成
        rental = Rental.create!(
          line_user_id: user_id,
          display_name: nil,
          uniform_info: "未選択",
          status: "requested",
          requested_at: Time.current
        )
        
        # LINE返信メッセージ
        reply_message = "申請ありがとうございます！この画面をスタッフにお見せください。\n注文番号は「#{rental.id}」です"
        
        send_reply(reply_token, reply_message)
      end
    end
    
    head :ok
  rescue => e
    Rails.logger.error "LINE Webhook error: #{e.message}"
    head :ok
  end

  private

  def send_reply(reply_token, message)
    line_api_url = "https://api.line.me/v2/bot/message/reply"
    headers = {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV['LINE_CHANNEL_ACCESS_TOKEN']}"
    }
    
    body = {
      replyToken: reply_token,
      messages: [{
        type: "text",
        text: message
      }]
    }.to_json

    response = Net::HTTP.post(URI(line_api_url), body, headers)
    
    if response.code == "200"
      Rails.logger.info "LINE reply sent successfully: #{message}"
    else
      Rails.logger.error "LINE reply failed: #{response.code} #{response.body}"
    end
  rescue => e
    Rails.logger.error "LINE reply error: #{e.message}"
  end
end
