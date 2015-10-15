module = angular.module('angular-unisson-auth', ['http-auth-interceptor', 'ngCookies', 'googleOauth', 'restangular'])

# Rest factories
module.factory('Groups', (Restangular) ->
        return Restangular.service('account/group')
)

module.factory('Users', (Restangular) ->
        return Restangular.service('account/user')
)

class LoginService
        """
        Login a user
        """
        constructor: (@$rootScope, @baseUrl, @$http, @$state, @Restangular, @$cookies, @authService, @Token) ->
                @$rootScope.authVars =
                        username : "",
                        isAuthenticated: false,
                        loginrequired : false

                # Custom restangular for this login URL
                @loginRestangular = Restangular.withConfig((RestangularConfigurer) ->
                        RestangularConfigurer.setBaseUrl(baseUrl)
                        RestangularConfigurer.setDefaultHttpFields({'ignoreAuthModule':true})
                )


                # On login required
                @$rootScope.$on('event:auth-loginRequired', =>
                        @$rootScope.authVars.loginrequired = true
                        console.debug("Login required")
                )

                # On login successful
                @$rootScope.$on('event:auth-loginConfirmed', =>
                        console.debug("Login OK")
                        @$rootScope.authVars.loginrequired = false
                        @$rootScope.authVars.username = @$cookies.username
                        @$rootScope.authVars.isAuthenticated = true
                        @loginRestangular.all('account/user').get(@$cookies.username).then((data)=>
                                        console.log("user object", data)
                                        @$rootScope.authVars.user = data
                                )
                )

                # set authorization header if already logged in
                if @$cookies.username and @$cookies.key
                        console.debug("Already logged in.")
                        @$http.defaults.headers.common['Authorization'] = "ApiKey #{@$cookies.username}:#{@$cookies.key}"
                        @authService.loginConfirmed()


                @$rootScope.accessToken = @Token.get()

                # Add methods to scope
                @$rootScope.submit = this.submit
                @$rootScope.authenticateGoogle = this.authenticateGoogle
                @$rootScope.forceLogin = this.forceLogin
                @$rootScope.logout = this.logout

        forceLogin: =>
                console.debug("forcing login on request")
                @$rootScope.authVars.loginrequired = true

        logout: =>
                @$rootScope.authVars.isAuthenticated = false
                delete @$http.defaults.headers.common['Authorization']
                delete @$cookies['username']
                delete @$cookies['key']
                @$rootScope.authVars.username = ""

                if @$rootScope.homeStateName
                        @$state.go(@$rootScope.homeStateName, {}, {reload:true})


        submit: =>
                console.debug('submitting login...')
                @loginRestangular.all('account/user').customPOST(
                        {username: @$rootScope.authVars.username, password: @$rootScope.authVars.password},"login", {}
                        ).then((data) =>
                                console.log(data)
                                @$cookies.username = data.username
                                @$cookies.key = data.key
                                @$http.defaults.headers.common['Authorization'] = "ApiKey #{data.username}:#{data.key}"
                                @loginRestangular.all('account/user').get(data.username).then((data)=>
                                        console.log("user object", data)
                                        @$rootScope.authVars.user = data
                                        @authService.loginConfirmed()
                                )

                        , (data) =>
                                console.debug("LoginController submit error: #{data.reason}")
                                @$rootScope.errorMsg = data.reason
                )

        authenticateGoogle: =>
                extraParams = {}
                if @$rootScope.askApproval
                        extraParams = {approval_prompt: 'force'}

                @Token.getTokenByPopup(extraParams).then((params) =>

                        # Verify the token before setting it, to avoid the confused deputy problem.
                        @loginRestangular.all('account/user/login').customPOST({access_token: params.access_token}, "google", {}).then((data) =>
                                @$cookies.username = data.username
                                @$cookies.key = data.key
                                @$http.defaults.headers.common['Authorization'] = "ApiKey #{data.username}:#{data.key}"
                                @authService.loginConfirmed()
                        , (data) =>
                                console.debug("LoginController submit error: #{data.reason}")
                                @$rootScope.errorMsg = data.reason
                        )
                , ->
                        # Failure getting token from popup.
                        alert("Failed to get token from popup.")
                )

module.provider("loginService", ->
        setBaseUrl: (baseUrl) ->
                @baseUrl = baseUrl

        $get: ($rootScope, $http, $state, Restangular, $cookies, authService, Token) ->
                return new LoginService($rootScope, @baseUrl, $http, $state, Restangular, $cookies, authService, Token)
)
