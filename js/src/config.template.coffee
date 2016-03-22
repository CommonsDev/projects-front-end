@config =
    templateBaseUrl: '/views/',
    useHtml5Mode: false,
    projectSheetTemplateSlug: 'unisson',
    defaultSiteTags: [],  # comma-separated list of site tags
    editorialSuggestedTags : [], # list of tags suggested instead of most popular ones
    defaultResultLimit : 28, # nb of results loaded by default in projects list page


    # Commons-dev patapouf server
    bucket_uri: 'http://example.org/bucket/upload/',
    loginBaseUrl: 'http://example.org/api/v0', # This can be different from rest_uri
    oauthBaseUrl: 'http://imagination.apps.patapouf.org', #path to oauth.html
    oauthCliendId: 'YOUR_OAUTH_ID',
    media_uri: 'http://example.org',
    rest_uri: "http://example.org/api/v0",
    dataserver_url: "http://example.org"
