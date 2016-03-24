# frozen_string_literal: true
require 'rack-http-accept-language'
require 'rack/test'
require 'json'

class TestRackApp
  def call(env)
    Rack::Request.new(env)
  end
end

describe 'Rack integration' do
  include Rack::Test::Methods

  def app
    Rack::Builder.new do
      use RackHttpAcceptLanguage::Middleware
      run TestRackApp.new
    end.to_app
  end

  context 'http_accept_language' do
    it 'handle one http_accept_language' do
      env = { 'HTTP_ACCEPT_LANGUAGE' => 'en' }
      app = ->(env) { env }
      middleware = RackHttpAcceptLanguage::Middleware.new(app)
      middleware.call(env)
      expect(env.rack_http_accept_language).to eq 'en'
      env['HTTP_ACCEPT_LANGUAGE'] = 'de'
      middleware.call(env)
      expect(env.rack_http_accept_language).to eq 'de'
    end

    it 'handle more http_accept_languages' do
      env = { 'HTTP_ACCEPT_LANGUAGE' => 'en-US,en-GB;q=0.8,en;q=0.6' }
      app = ->(env) { env }
      middleware = RackHttpAcceptLanguage::Middleware.new(app)
      middleware.call(env)
      expect(env.rack_http_accept_language).to eq 'en-US'
    end
  end

  context 'http_accept_languages' do
    it 'handle one http_accept_language' do
      env = { 'HTTP_ACCEPT_LANGUAGE' => 'en' }
      app = ->(env) { env }
      middleware = RackHttpAcceptLanguage::Middleware.new(app)
      middleware.call(env)
      expect(env.rack_http_accept_languages).to eq %w(en)
      env['HTTP_ACCEPT_LANGUAGE'] = 'de'
      middleware.call(env)
      expect(env.rack_http_accept_languages).to eq %w(de)
    end

    it 'handle more http_accept_languages' do
      env = { 'HTTP_ACCEPT_LANGUAGE' => 'en-US,en-GB;q=0.5,en;q=0.7' }
      app = ->(env) { env }
      middleware = RackHttpAcceptLanguage::Middleware.new(app)
      middleware.call(env)
      expect(env.rack_http_accept_languages).to eq %w(en-US en en-GB)
    end
  end
end
