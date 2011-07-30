Singal
==============

Highly modified version of [Picawing](http://github.com/matthewl/picawing) originally by [mathewl](http://github.com/matthewl)

Image gallery, for sharing images uploaded to Picasa.

Features
-------

* Ability to show your private albums/pictures
* Pull images from multiple albums
* Caching of picasa albums for large amounts of images

To Do
-----

* A easy way to turn caching on and off
* Add tests

How?
----

* [Sinatra](http://sinatrarb.com) (Micro Web-framework)
* [MongoDB](http://www.mongodb.org) (Document-oriented Database)
* [Mongoid](https://github.com/mongoid/mongoid) (ODM)
* [NokoGiri](http://nokogiri.org) (XML Parser)
* [HAML](http://haml-lang.com) (Markup)
* [jQuery](http://jquery.com) (Javascript Framework)
* [Sammy](http://sammyjs.org) (Javascript Application DSL)
* [ColorBox](http://colorpowered.com/colorbox) (Lightbox)
* [Head JS](http://headjs.com) (Javascript Loader)

Setup
-----
__Requirements:__

* MongoDB
* Ruby

1. Clone repository
2. Rename config.yml.example to config.yml
3. Modify said files with your information
4. `bundle install`
6. `rake picasa:cache` (may take some time depending on amount of images and your connection/computer).
7. `script/server`