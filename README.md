# Haipa

HAL hypermedia media client built on Faraday.

## Installation

Add this line to your application's Gemfile:

    gem 'haipa'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install haipa

## Usage

Haipa.api creates a new Haipa::Api object. The initializer's parameters and block
are passed straight through to Faraday's connection initializer so you have full
access to all of Faraday's settings, including adapter and middlewares.

At the moment the only additions Haipa makes to the Faraday default is to add
the accepts header application/hal+json and the user agent header Haipa. This
defaults are deep merged with the settings passed to the initializer so they can
be overridden.

Given a API root description

    {
      "_links" :
      {
        "self" :   { "href" : "/api/v1" },
        "things" : { "href" : "/api/v1/things" }
      }
    }

and a thing index resource

    {
      "_embedded" : {
        "things" => [
          {
            "name" => "thing1",
            "_links" : { "self" : { "href" : "/api/v1/things/thing1" } }
          },
          {
            "name" => "thing2",
            "_links" : { "self" : { "href" : "/api/v1/things/thing2" } }
          }
        ]
      },
      "_links" : {
        "self" : { "href" : "/api/v1/things" }
      }
    }

Then Haipa can consume this API with

    api = Haipa.api(url:'http://localhost:3000/api/v1')
    api.description # the root as a hash
    api.resource # the root as a Haipa::Resource
    api.links # the root links as a Haipa::Links
    api.href # the uri of the root
    api.embedded # the embedded resource array Haipa::Embedded
    api.resources # alias of api.embedded

    link = api.links
    links.things # the things Haipa::Resource

    things = links.things
    things.links # the things index Haipa::Links
    things.embedded # the things index Haipa::Embedded

    embedded = things.embedded
    embedded.things # array of Haipa::Resource
    embedded.things.first # the first embedded thing Haipa::Resource
    embedded.things.first.name # the first embedded thing Haipa::Resource name
    embedded.things[1] # the second embedded thing Haipa::Resource
    embedded.things.first.clear.other_attribute



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
