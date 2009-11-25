# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_facebook_app_session',
  :secret      => '54faf171d4c20b98de98b918b4869b4740565a12d3826b832af2b60416d12c976e659bcb1a3741a3d4f195c7ee1885fc0a57a2800e3306f0f78726baafff0563'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
