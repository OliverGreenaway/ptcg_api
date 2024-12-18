# frozen_string_literal: true

# Assuming you have not yet modified this file, each configuration option below
# is set to its default value. Note that some are commented out while others
# are not: uncommented lines are intended to protect your configuration from
# breaking changes in upgrades (i.e., in the event that future versions of
# Devise change the default values for those options).
#
# Use this hook to configure devise mailer, warden hooks and so forth.
# Many of these configuration options can be set straight in your model.
Devise.setup do |config|
  # ==> ORM configuration
  # Load and configure the ORM. Supports :active_record (default) and
  # :mongoid (bson_ext recommended) by default. Other ORMs may be
  # available as additional gems.
  require 'devise/orm/active_record'

  # Configure which authentication keys should be case-insensitive.
  # These keys will be downcased upon creating or modifying a user and when used
  # to authenticate or find a user. Default is :email.
  config.case_insensitive_keys = [:email]

  # Configure which authentication keys should have whitespace stripped.
  # These keys will have whitespace before and after removed upon creating or
  # modifying a user and when used to authenticate or find a user. Default is :email.
  config.strip_whitespace_keys = [:email]

  # By default Devise will store the user in session. You can skip storage for
  # particular strategies by setting this option.
  # Notice that if you are skipping storage for all authentication paths, you
  # may want to disable generating routes to Devise's sessions controller by
  # passing skip: :sessions to `devise_for` in your config/routes.rb
  config.skip_session_storage = [:http_auth]

  # ==> Configuration for :database_authenticatable
  # For bcrypt, this is the cost for hashing the password and defaults to 12. If
  # using other algorithms, it sets how many times you want the password to be hashed.
  # The number of stretches used for generating the hashed password are stored
  # with the hashed password. This allows you to change the stretches without
  # invalidating existing passwords.
  #
  # Limiting the stretches to just one in testing will increase the performance of
  # your test suite dramatically. However, it is STRONGLY RECOMMENDED to not use
  # a value less than 10 in other environments. Note that, for bcrypt (the default
  # algorithm), the cost increases exponentially with the number of stretches (e.g.
  # a value of 20 is already extremely slow: approx. 60 seconds for 1 calculation).
  config.stretches = Rails.env.test? ? 1 : 12

  # Invalidates all the remember me tokens when the user signs out.
  config.expire_all_remember_me_on_sign_out = true

  # ==> Configuration for :validatable
  # Range for password length.
  config.password_length = 6..128

  # Email regex used to validate email formats. It simply asserts that
  # one (and only one) @ exists in the given string. This is mainly
  # to give user feedback and not to assert the e-mail validity.
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # ==> Navigation configuration
  # Lists the formats that should be treated as navigational. Formats like
  # :html should redirect to the sign in page when the user does not have
  # access, but formats like :xml or :json, should return 401.
  #
  # If you have any extra navigational formats, like :iphone or :mobile, you
  # should add them to the navigational formats lists.
  #
  # The "*/*" below is required to match Internet Explorer requests.
  config.navigational_formats = []

  # The default HTTP method used to sign out a resource. Default is :delete.
  config.sign_out_via = :delete

  # ==> Hotwire/Turbo configuration
  # When using Devise with Hotwire/Turbo, the http status for error responses
  # and some redirects must match the following. The default in Devise for existing
  # apps is `200 OK` and `302 Found` respectively, but new apps are generated with
  # these new defaults that match Hotwire/Turbo behavior.
  # Note: These might become the new default in future versions of Devise.
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other

  config.api.configure do |api|
    # Access Token
    api.access_token.expires_in = 2.minutes
    api.access_token.expires_in_infinite = ->(_resource_owner) { false }
    api.access_token.generator = ->(_resource_owner) { Devise.friendly_token(60) }

    # Refresh Token
    api.refresh_token.enabled = true
    api.refresh_token.expires_in = 1.week
    api.refresh_token.generator = ->(_resource_owner) { Devise.friendly_token(60) }
    api.refresh_token.expires_in_infinite = ->(_resource_owner) { false }

    # Sign up
    api.sign_up.enabled = false
    api.sign_up.extra_fields = []

    # Authorization
    api.authorization.key = 'Authorization'
    api.authorization.scheme = 'Bearer'
    api.authorization.location = :both # :header or :params or :both
    api.authorization.params_key = 'access_token'


    # Base classes
    api.base_token_model = 'Devise::Api::Token'
    api.base_controller = '::DeviseController'


    # After successful callbacks
    api.after_successful_sign_in = ->(_resource_owner, _token, _request) { }
    api.after_successful_sign_up = ->(_resource_owner, _token, _request) { }
    api.after_successful_refresh = ->(_resource_owner, _token, _request) { }
    api.after_successful_revoke = ->(_resource_owner, _token, _request) { }


    # Before callbacks
    api.before_sign_in = ->(_params, _request, _resource_class) { }
    api.before_sign_up = ->(_params, _request, _resource_class) { }
    api.before_refresh = ->(_token_model, _request) { }
    api.before_revoke = ->(_token_model, _request) { }
  end
end
