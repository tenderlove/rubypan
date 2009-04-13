# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rpan_session',
  :secret      => 'd6c0c955040f6e6de688a6854a0b53316c8149f2a5d4a9b4c1f773c7a394507186334df4d9ac92a7af86262f76506be5245448b3bf7c93f2ad419ba6d84773bb'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
