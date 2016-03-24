# frozen_string_literal: true
require 'rack-http-accept-language'
require 'rack/test'
require 'json'

class TestRackHttpAcceptLanguageApp
  def call(env)
    rack_http_accept_language = env.rack_http_accept_language
    rack_http_accept_languages = env.rack_http_accept_languages

    result = {
      preferred_language: rack_http_accept_language,
      preferred_languages: rack_http_accept_languages
    }
    [200, {}, [JSON.generate(result)]]
  end
end

describe 'Rack integration' do
  include Rack::Test::Methods

  def app
    Rack::Builder.new do
      use RackHttpAcceptLanguage::Middleware
      run TestRackHttpAcceptLanguageApp.new
    end.to_app
  end

  def call_get_method(http_accept_language)
    get '/', {}, { 'HTTP_ACCEPT_LANGUAGE' => http_accept_language }
  end

  def response
    JSON.parse(last_response.body)
  end

  context 'use middleware with test app' do
    it 'decodes the HTTP_ACCEPT_LANGUAGE header' do
      http_accept_language = 'en-US,en-GB;q=0.8,en;q=0.6,es-419'
      get '/', {}, { 'HTTP_ACCEPT_LANGUAGE' => http_accept_language }
      expect(response['preferred_language']).to eq 'en-US'
    end

    it 'decodes the HTTP_ACCEPT_LANGUAGE header' do
      http_accept_language = 'en-US,en-GB;q=0.8,en;q=0.6,es-419'
      get '/', {}, { 'HTTP_ACCEPT_LANGUAGE' => http_accept_language }
      expect(response['preferred_languages']).to eq %w(en-US es-419 en-GB en)
    end
  end

  context 'call middleware directly' do
    context 'without i18n' do
      let(:app) { ->(env_data) { env_data } }
      let(:middleware) { RackHttpAcceptLanguage::Middleware.new(app) }

      context 'http_accept_language' do
        it 'handle one http_accept_language' do
          env = { 'HTTP_ACCEPT_LANGUAGE' => 'en' }
          middleware.call(env)
          expect(env.rack_http_accept_language).to eq 'en'
          env['HTTP_ACCEPT_LANGUAGE'] = 'de'
          middleware.call(env)
          expect(env.rack_http_accept_language).to eq 'de'
        end

        it 'handle more http_accept_languages' do
          env = { 'HTTP_ACCEPT_LANGUAGE' => 'en-US,en-GB;q=0.8,en;q=0.6' }
          middleware.call(env)
          expect(env.rack_http_accept_language).to eq 'en-US'
        end
      end

      context 'http_accept_languages' do
        it 'handle one http_accept_language' do
          env = { 'HTTP_ACCEPT_LANGUAGE' => 'en' }
          middleware.call(env)
          expect(env.rack_http_accept_languages).to eq %w(en)
          env['HTTP_ACCEPT_LANGUAGE'] = 'de'
          middleware.call(env)
          expect(env.rack_http_accept_languages).to eq %w(de)
        end

        it 'handle more http_accept_languages' do
          env = { 'HTTP_ACCEPT_LANGUAGE' => 'en-US,en-GB;q=0.5,en;q=0.7' }
          middleware.call(env)
          expect(env.rack_http_accept_languages).to eq %w(en-US en en-GB)
        end
      end
    end
  end
end
