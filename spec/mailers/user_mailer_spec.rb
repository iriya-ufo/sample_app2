require "rails_helper"

describe "account_activation", type: :mailer do
  it "renders the headers and the body" do
    user = create(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    expect(mail.subject).to eq("Account activation")
    expect(mail.to).to eq([user.email])
    expect(mail.from).to eq(["noreply@example.com"])
    expect(mail.body.encoded).to match(user.name)
    expect(mail.body.encoded).to match(user.activation_token)
    expect(mail.body.encoded).to match(CGI.escape(user.email))
  end
end