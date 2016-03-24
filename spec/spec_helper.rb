# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rack-http-accept-language'
require 'codeclimate-test-reporter'
require 'simplecov'

SimpleCov.start
CodeClimate::TestReporter.start
