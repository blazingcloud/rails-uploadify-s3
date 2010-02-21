# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rails-uploadify-s3_session',
  :secret      => '73de1d249bd05cff9d6bb5ff00476a98e564978390b91ee98bcaca3ffafdb037d5d1b01892e01dbb724daa713b3cb4f07335425f95dd38b9fd0eb6c7da69a074'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
