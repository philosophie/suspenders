if ENV['SMTP_PROVIDER'] == 'sendgrid'
  SMTP_USERNAME = ENV.fetch 'SENDGRID_USERNAME'
  SMTP_PASSWORD = ENV.fetch 'SENDGRID_PASSWORD'
else
  SMTP_USERNAME = ENV.fetch 'SMTP_USERNAME'
  SMTP_PASSWORD = ENV.fetch 'SMTP_PASSWORD'
end

SMTP_SETTINGS = {
  address: ENV.fetch('SMTP_ADDRESS'), # example: "smtp.sendgrid.net"
  authentication: :plain,
  domain: ENV.fetch('SMTP_DOMAIN'), # example: "heroku.com"
  enable_starttls_auto: true,
  password: SMTP_PASSWORD,
  port: '587',
  user_name: SMTP_USERNAME
}.freeze
