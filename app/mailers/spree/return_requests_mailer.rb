class Spree::ReturnRequestsMailer < ActionMailer::Base

  def submitted(return_request)
    mail to: return_request.email_address, from: site_owner_email, subject: Spree.t(:submitted, :scope => :mailer)
  end

  def submitted_admin(return_request)
    @return_request = return_request
    mail to: site_owner_email, from: site_owner_email, subject: Spree.t(:submitted_admin, :scope => :mailer)
  end

  def approved(return_request)
    @return_request = return_request
    mail to: return_request.email_address, from: site_owner_email, subject: Spree.t(:approved, :scope => :mailer)
  end

  private

    def site_owner_email
      Spree::Config[:mails_from]
    end
end
