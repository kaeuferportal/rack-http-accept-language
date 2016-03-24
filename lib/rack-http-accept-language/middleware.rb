# frozen_string_literal: true
module RackHttpAcceptLanguage
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      parser = Parser.new(env['HTTP_ACCEPT_LANGUAGE'])
      env['http_accept_language'] = parser.preferred_language
      env['http_accept_languages'] = parser.preferred_languages

      def env.http_accept_languages
        self['http_accept_languages']
      end

      def env.http_accept_language
        self['http_accept_language']
      end

      @app.call(env)
    end
  end
end
