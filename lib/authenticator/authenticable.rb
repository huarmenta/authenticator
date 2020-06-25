# frozen_string_literal: true

module Authenticator
  # Adds custom authentication functionality for any model by calling the
  # authenticate_for(entity_class) method.
  module Authenticable
    # Creates a custom getter method to return an instance of the model based
    # on the entity_class parameter and calls it.
    # f.e. authenticate_for(User) where User is a Model of the application.
    def authenticate_for(entity_class)
      getter_name = "current_#{entity_class.to_s.underscore}"

      define_current_entity_getter(entity_class, getter_name) unless respond_to?(getter_name)

      public_send(getter_name)
    end

    private

    def token
      @token ||= token_from_params || token_from_request_headers || token_from_cookies

      return @token if @token

      raise(JWTExceptionHandler::MissingToken, 'Missing token')
    end

    def method_missing(method_name, *args)
      entity_name = method_name.to_s.split('_').last

      super unless authenticate_entity(entity_name)
    end

    def respond_to_missing?(method_name, include_private = false)
      super
    end

    def authenticate_entity(entity_name)
      send(:authenticate_for, entity_name.camelize.constantize)
    end

    def token_from_params
      params[:jwt] || params['token']
    end

    def token_from_request_headers
      request.headers['Authorization'].try(:split).try(:last)
    end

    def token_from_cookies
      cookies.signed[:jwt]
    end

    def define_current_entity_getter(entity_class, getter_name)
      memoization_var_name = "@_#{getter_name}"
      self.class.send(:define_method, getter_name) do
        unless instance_variable_defined?(memoization_var_name)
          current = Authenticator::AuthorizeApiRequest.call(
            token: token, entity_class: entity_class
          )
          instance_variable_set(memoization_var_name, current)
        end
        instance_variable_get(memoization_var_name)
      end
    end
  end
end
