How to use ?
############

It requires following rootScope variables to work:

  $rootScope.homeStateName : the name of the state (depends on stateProvider service) to redirect after logout

In a `app.config()`, call 'loginServiceProvider' and use:

   $loginServiceProvider.setBaseUrl(YOUR_BASE_URL)

YOUR_BASE_URL is the absolute base url of login API. E.g if "http://fuzzy.com/api/v0/ is given, 
service will attempt to login to "fuzzy.com/api/v0/account/user/login" 
and will provide credentials in the form of an object as { username:"myusername", password:"mypassword" }

Versions change
###############

#0.1.7
Fixed an issue with angular-http-auth (https://github.com/witoldsz/angular-http-auth/issues/25) 
where users who entered wrong credentials are always prompted for credentials, even after submitting 
right ones and being connected. 