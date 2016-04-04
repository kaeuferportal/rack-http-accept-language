# RackHttpAcceptLanguage
[![Build Status](https://travis-ci.org/kaeuferportal/rack-http-accept-language.svg?branch=master)](https://travis-ci.org/kaeuferportal/rack-http-accept-language)

## Possible Methods

You have two methods on the ``env`` object:
```
rack_http_accept_lanugage
```
and
```
rack_http_accept_lanugages
```

## How you can use it with Sinatra

```
class App < Sinatra::Base
  use RackHttpAcceptLanguage::Middleware

  post '/' do
    I18n.locale = request.env.rack_http_accept_language
  end
end
```


## Installation

Add the gem to your Gemfile:

``` ruby
gem 'rack-http-accept-language'
```

Run `bundle install` to install it.
