class LineController < ApplicationController
  protect_from_forgery except: :webhook

  def webhook
    Rails.logger.info "LINE Webhook received: #{request.body.read}"
    head :ok
  rescue => e
    Rails.logger.error "LINE Webhook error: #{e.message}"
    head :ok
  end
end
