class ContactMailer < ApplicationMailer
  # Powiadomienie do pracowni o nowym zapytaniu z formularza.
  def notification(inquiry)
    @inquiry = inquiry
    mail(
      to: ENV.fetch("CONTACT_RECIPIENT", "kontakt@jnk-studio.com"),
      reply_to: inquiry.email,
      subject: "Nowe zapytanie — #{inquiry.name}"
    )
  end
end
