# frozen_string_literal: true
require 'spec_helper'

describe RackHttpAcceptLanguage::Parser do
  context 'without wildcard' do
    context 'no upcase handling necessary' do
      let(:http_accept_language) { 'en-US,en-GB;q=0.6,en;q=0.8' }
      subject(:parser) { described_class.new(http_accept_language) }

      it 'preferred language' do
        expected_array = 'en-US'
        expect(parser.preferred_language).to eq expected_array
      end

      it 'preferred_languages' do
        expected_array = ['en-US', 'en', 'en-GB']
        expect(parser.preferred_languages).to eq expected_array
      end
    end

    context 'upcase necessary' do
      let(:http_accept_language) { 'en-us,en-GB;q=0.6,en;q=0.8' }
      subject(:parser) { described_class.new(http_accept_language) }

      it 'preferred language' do
        expected_array = 'en-US'
        expect(parser.preferred_language).to eq expected_array
      end

      it 'preferred_languages' do
        expected_array = ['en-US', 'en', 'en-GB']
        expect(parser.preferred_languages).to eq expected_array
      end
    end
  end

  context 'with wildcard' do
    describe '.preferred_language' do
      it 'has no http_accept_language' do
        http_accept_language = nil
        parser = described_class.new(http_accept_language)

        expect(parser.preferred_language).to eq nil
      end

      it 'has a * as http_accept_language' do
        http_accept_language = '*'
        parser = described_class.new(http_accept_language)

        expect(parser.preferred_language).to eq nil
      end

      it 'has a * in http_accept_language' do
        http_accept_language = '*,en;q=0.6'
        parser = described_class.new(http_accept_language)

        expect(parser.preferred_language).to eq 'en'
      end
    end

    describe '.preferred_languages' do
      it 'has no http_accept_languages' do
        http_accept_language = nil
        parser = described_class.new(http_accept_language)

        expect(parser.preferred_languages).to eq nil
      end

      it 'has a * as http_accept_languages' do
        http_accept_language = '*'
        parser = described_class.new(http_accept_language)

        expect(parser.preferred_languages).to eq nil
      end

      it 'has a * in http_accept_languages' do
        http_accept_language = '*,en;q=0.6'
        parser = described_class.new(http_accept_language)

        expect(parser.preferred_languages).to eq %w(en)
      end
    end
  end
end
