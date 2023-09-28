# app/mailers/receipt_mailer.rb

class ReceiptMailer < ApplicationMailer
    def send_receipt(user, order)
      @user = user
      @order = order
  
      mail(
        to: user.email,
        subject: "Your Receipt for Order ##{order.id}"
      )
    end
  end
  