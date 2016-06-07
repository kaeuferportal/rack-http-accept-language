# frozen_string_literal: true
module RackHttpAcceptLanguage
  class Parser
    attr_reader :http_accept_language

    def initialize(http_accept_language)
      @http_accept_language = http_accept_language
    end

    def preferred_language
      return nil if early_return?
      order_languages_by_qvalue.first
    end

    def preferred_languages
      return nil if early_return?
      order_languages_by_qvalue
    end

    private

    def early_return?
      http_accept_language.nil? || http_accept_language == '*'
    end

    def order_languages_by_qvalue
      order_languages_by_qvalue_hash.values.flatten
    end

    def split_languages
      @split_languages ||= http_accept_language.to_s.split(',')
    end

    def order_languages_by_qvalue_hash
      @order_languages_by_qvalue ||=
        split_languages.each_with_object({}) do |language_with_qvalue, memo|
          language, qvalue = language_with_qvalue.split(';q=')
          next if language == '*'

          handle_language(language, qvalue, memo)
        end.sort.reverse.to_h
    end

    def handle_language(language, qvalue, memo)
      language = language.strip.downcase.gsub(/-[a-z0-9]+$/i, &:upcase)
      qvalue = qvalue ? qvalue.to_f : 1.0

      if memo[qvalue].nil?
        memo[qvalue] = [language]
      else
        memo[qvalue] << language
      end
    end
  end
end
