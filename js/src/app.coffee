angular.module('commons.base', ['commons.base.controllers', 'commons.base.services'])
angular.module('commons.catalog', ['commons.catalog.controllers', 'commons.catalog.services'])
angular.module('commons.accounts', ['commons.accounts.services', 'commons.accounts.controllers'])
angular.module('commons.ucomment', ['commons.ucomment.controllers', 'commons.ucomment.services'])
angular.module('makerscience.catalog', ['makerscience.catalog.controllers', 'makerscience.catalog.services', 'makerscience.catalog.directives'])
angular.module('makerscience.profile', ['makerscience.profile.controllers', 'makerscience.profile.services'])
angular.module('makerscience.base', ['makerscience.base.controllers', 'makerscience.base.services'])
angular.module('makerscience.map', ['makerscience.map.controllers'])
angular.module('makerscience', ['commons.catalog', 'commons.accounts', 'commons.ucomment', 'commons.base', 
                                'makerscience.catalog', 'makerscience.profile', 'makerscience.base','makerscience.map',
                                'restangular', 'ui.bootstrap', 'ui.router', 'xeditable', 'textAngular', 'angularjs-gravatardirective', 'angularFileUpload',
                                'ngSanitize', 'ngTagsInput', 'angularMoment', 'angular-unisson-auth', 'leaflet-directive', "angucomplete-alt", "videosharing-embed"
                                'geocoder-service', 'ncy-angular-breadcrumb', 'truncate'])

# CORS
.config(['$httpProvider', ($httpProvider) ->
        $httpProvider.defaults.useXDomain = true
        delete $httpProvider.defaults.headers.common['X-Requested-With']
])

# Tastypie
.config((RestangularProvider) ->
        RestangularProvider.setBaseUrl(config.rest_uri)
        RestangularProvider.setRequestSuffix('?format=json');
        # Tastypie patch
        RestangularProvider.setResponseExtractor((response, operation, what, url) ->
                newResponse = null;

                if operation is "getList"
                        newResponse = response.objects
                        newResponse.metadata = response.meta
                else
                        newResponse = response

                return newResponse
        )
)
# Google auth config
.config(['TokenProvider', '$locationProvider', (TokenProvider, $locationProvider) ->
    TokenProvider.extendConfig(
        clientId: '255067193649-gsukme1nnpu55pfd7q3b589lhmih3qg1.apps.googleusercontent.com',
        redirectUri: config.oauthBaseUrl+'/oauth2callback.html',
        scopes: ["https://www.googleapis.com/auth/userinfo.email", "https://www.googleapis.com/auth/userinfo.profile"],
    )
])
# Unisson auth config
.config((loginServiceProvider) ->
    loginServiceProvider.setBaseUrl(config.loginBaseUrl)
)
# URI config
.config(['$locationProvider', '$stateProvider', '$urlRouterProvider', ($locationProvider, $stateProvider, $urlRouterProvider) ->

        $locationProvider.html5Mode(config.useHtml5Mode)
        $urlRouterProvider.otherwise("/")

        $stateProvider.state('home',
                url: '/',
                templateUrl: 'views/homepage.html',
                ncyBreadcrumb:
                    label: 'Accueil'
        )
        .state('project',
                url: '/p/'
                abstract: true,
                templateUrl : 'views/catalog/project.html'
                ncyBreadcrumb:
                    parent: 'home'
        )
        .state('project.list',
                url: 'list',
                templateUrl: 'views/catalog/project.list.html',
                ncyBreadcrumb:
                    label: 'Projets'
        )
        .state('project.new',
                url: 'new',
                templateUrl: 'views/catalog/project.new.html',
                ncyBreadcrumb:
                    label: 'Nouveau projet'
                    parent : 'project.list'
        )
        .state('project.detail',
                url: ':slug',
                templateUrl: 'views/catalog/project.detail.html',
                controller : 'ProjectSheetCtrl'
                ncyBreadcrumb:
                    label: '{{project.title}}'
                    parent : 'project.list'
        )
        .state('profile',
                url : '/u/',
                abstract : true,
                templateUrl : 'views/profile/profile.html'
                ncyBreadcrumb:
                    parent: 'home'
        )
        .state('profile.list',
                url: 'list',
                templateUrl: 'views/profile/profile.list.html'
                ncyBreadcrumb:
                    label: 'Communauté'
        )
        .state('profile.detail',
                url: ':slug',
                templateUrl: 'views/profile/profile.detail.html'
                controller : 'MakerScienceProfileCtrl'
                ncyBreadcrumb:
                    label: '{{profile.full_name}}'
                    parent : 'profile.list'
        )
        .state('profile.dashboard',
                url: ':slug/dashboard',
                templateUrl: 'views/profile/profile.dashboard.html'
                controller : 'MakerScienceProfileCtrl'
                ncyBreadcrumb:
                    label: '{{profile.full_name}}'
                    parent : 'profile.detail'
        )
        .state('map',
                url: '/map/',
                templateUrl: 'views/map/map.html'
                ncyBreadcrumb:
                    label: 'Carte de la communauté'
                    parent : 'profile.list'
        )
        .state('about',
                url: '/about/',
                templateUrl: 'views/base/about.html'
                ncyBreadcrumb:
                    label: 'A propos'
                    parent : 'home'
        )
        .state('forum',
                url: '/discussions/',
                templateUrl: 'views/base/forum.html'
                ncyBreadcrumb:
                    label: 'Forum'
                    parent : 'home'
        )
        .state('tags',
                url: '/tags/',
                templateUrl: 'views/base/tag_listing.html'
                ncyBreadcrumb:
                    label: 'Tags'
                    parent : 'home'
        )
        .state('tag',
                url: '/tag/:slug',
                templateUrl: 'views/base/tagged_objects.html'
                controller : 'TaggedItemCtrl'
                ncyBreadcrumb:
                    label: '{{tag.slug}}'
                    parent : 'tags'
        )
        .state('search',
                url: '/search/:query',
                templateUrl: 'views/base/search_result.html'
                controller : 'MakerScienceSearchCtrl'
                ncyBreadcrumb:
                    label: 'Recherche'
                    parent : 'home'
        )

])
.run(($rootScope, editableOptions, editableThemes, amMoment, loginService, $state, $stateParams, CurrentMakerScienceProfileService) ->
    editableOptions.theme = 'bs3'
    editableThemes['bs3'].submitTpl = '<button type="submit" class="btn btn-primary">Enregistrer</button>'
    editableThemes['bs3'].cancelTpl = '<button type="button" class="btn btn-default" ng-click="$form.$cancel()">Annuler</button>'

    amMoment.changeLocale('fr');
    $rootScope.loginService = loginService
    $rootScope.config = config
    $rootScope.$state = $state
    $rootScope.$stateParams = $stateParams
    $rootScope.CurrentMakerScienceProfileService = CurrentMakerScienceProfileService

    $rootScope.Math = window.Math
)

angular.module('xeditable').directive('editableTextAngular', ['editableDirectiveFactory', (editableDirectiveFactory) ->
    return editableDirectiveFactory(
            directiveName : 'editableTextAngular'
            inputTpl : '<div text-angular></div>'
    )]
)