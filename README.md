

Project platform HTML FrontEnd
===========

A Projet front-end companion for the Data Server.

## Requirements

  * Ruby 1.9+
  * [Node.js](http://nodejs.org)
  * [compass](http://compass-style.org/): `gem install compass`
  * [bower](http://bower.io): `npm install bower -g`

Installation
=====

   sudo aptitude install ruby-compass ruby-fssm coffeescript 

   git clone https://github.com/UnissonCo/projects-front-end.git

   cd js/src

   nano config.coffee

#### If using localhost:8002 as a dataserver, use this configuration (default configuration) :

    bucket_uri: 'http://localhost:8002/bucket/upload/',
    loginBaseUrl: 'http://localhost:8002/api/v0', # This can be different from rest_uri
    oauthBaseUrl: 'Ajouter ici l'url de votre site', #path to oauth.html
    oauthCliendId: 'Ajouter ici l'ID d'authentification google',
    media_uri: 'http://localhost:8002',
    rest_uri: "http://localhost:8002/api/v0",
    dataserver_url: "http://localhost:8002"


   ./coffee_watch.sh

   cd ..

   cd ..

   cd css

   compass w

   cd ..

   npm install

   node_modules/.bin/bower install

   python -m SimpleHTTPServer 8080


Personnaliation
===============

Vous pouvez personnaliser votre installation avec le fichier config.coffee (à regénérer après chaque modification):


    projectSheetTemplateSlug: 'accompagnement',
    # Pour proposer un autre modèle de questions sur les fiches projets

    defaultSiteTags: [],  # comma-separated list of site tags
    # Pour choisir un tag par défaut qui filtrera tout le site selon ce tag

    editorialSuggestedTags : ['tag1', 'tag2'],
    # List of tags suggested instead of most popular ones

    defaultResultLimit : 25,
    # nb of results loaded by default in projects list page
