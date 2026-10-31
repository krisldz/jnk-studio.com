class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAIL_FROM", "JNK Studio <noreply@jnk-studio.com>")
  layout "mailer"
end
