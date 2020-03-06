require "google_drive"

session = GoogleDrive::Session.from_config("config.json")

session.upload_from_file("/email.JSON/email.rb", "email.rb", convert: false)



