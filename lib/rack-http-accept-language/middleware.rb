# frozen_string_literal: true
module RackHttpAcceptLanguage
  class Middleware
    def initialize(app)
      @app = app
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

      @app.call(env)
    end
  end
end
