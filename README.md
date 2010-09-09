Picawing Redux
==============

Highly modified version of [Picawing](http://github.com/matthewl/picawing) originally by [mathewl](http://github.com/matthewl)

Written in ruby and using the [Sinatra](http://sinatrarb.com) as the web framework.

Also uses:

* [Datamapper](http://datamapper.org) (ORM)
* [NokoGiri](http://nokogiri.org) (XML Parser)
* [HAML](http://haml-lang.com) (Markup Language)
* [DM-Pager](http://github.com/visionmedia/dm-pagination) (Pagination)
* [jQuery](http://jquery.com) (Javascript Framework)
* [ColorBox](http://colorpowered.com/colorbox) (Lightbox)

Changes
-------

* Ability to view private albums/pictures
* Gallery including all your albums
* Switch to haml
* Database caching of urls for large amounts of images
* Album only view at /albums/5499581012762369889 (Album ID)
* Pagination
* Testing! (Well at least a start)

To Do
-----

* A easy way to turn caching on and off
* Refactor rake task into class
* More testing
* Some re-factoring... especially naming conventions

Setup
-----
__Requirements:__

* Mysql (Will probably work with most any other relational database)
* Ruby
`gem install mysql datamapper dm-mysql-adapter dm-pager haml nokogiri sinatra rack-test`

1. Clone repository
2. Rename database.yml.example, database.rb.example (Remove .example)
3. Modify said files with your mysql information
4. run `rake db:migrate` in app directory
5. Rename picasa.yml.example and modify information
6. run `rake picasa:parse` to cache photo information (may take some time depending on amount of images and your connection/computer).
7. run `ruby application.rb` in app directory