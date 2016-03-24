# frozen_string_literal: true
module RackHttpAcceptLanguage
  class Middleware
    def initialize(app, i18n_default = false)
      @app = app
      @i18n_default = i18n_default
    end

    def call(env)
      parser = Parser.new(env['HTTP_ACCEPT_LANGUAGE'])
      env['RACK_HTTP_ACCEPT_LANGUAGE'] = parser.preferred_language
      env['RACK_HTTP_ACCEPT_LANGUAGES'] = parser.preferred_languages

      def env.rack_http_accept_languages
        self['RACK_HTTP_ACCEPT_LANGUAGES']
      end

      def env.rack_http_accept_language
        self['RACK_HTTP_ACCEPT_LANGUAGE']
      end

      set_i18n_default_value(parser.preferred_language) if @i18n_default

      @app.call(env)
    end

    def set_i18n_default_value(preferred_language)
      I18n.locale = preferred_language
    end
  end
end
