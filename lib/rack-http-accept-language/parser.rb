# frozen_string_literal: true
module RackHttpAcceptLanguage
  class Parser
    def initialize(http_accept_language)
      @http_accept_language = http_accept_language
    end

    def preferred_language
      order_languages_by_qvalue.values.first
    end

    def preferred_languages
      order_languages_by_qvalue.values
    end

    private

    def split_languages
      @split_languages ||= @http_accept_language.split(',')
    end

    def order_languages_by_qvalue
      @order_languages_by_qvalue ||=
        split_languages.each_with_object({}) do |language_with_qvalue, memo|
          language, qvalue = language_with_qvalue.split(';q=')
          qvalue = qvalue ? qvalue.to_f : 1.0

          memo[qvalue] = language
        end.sort.reverse.to_h
    end
  end
end
