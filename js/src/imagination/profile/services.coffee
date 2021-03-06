module = angular.module("imagination.profile.services", ['commons.accounts.services'])
#
# # Restangular-based Services
# module.factory('MakerScienceProfile', (Restangular) ->
#     return Restangular.service('makerscience/profile')
# )
#
# module.factory('MakerScienceProfileTaggedItem', (Restangular) ->
#     return Restangular.service('makerscience/profiletaggeditem')
# )
#
# # Specific services
# class CurrentMakerScienceProfileService
#     constructor : ($rootScope, $modal, MakerScienceProfile) ->
#
#         $rootScope.$watch('authVars.user', (newValue, oldValue) ->
#             if newValue != oldValue
#                 MakerScienceProfile.one().get({parent__user__id : $rootScope.authVars.user.id}).then((profileResult)->
#                     $rootScope.currentMakerScienceProfile = profileResult.objects[0]
#                 )
#         )
#
#         $rootScope.openSignupPopup = ()->
#             modalInstance = $modal.open(
#                 templateUrl: 'views/base/signupModal.html',
#                 controller: 'SignupPopupCtrl'
#             )
#
#         $rootScope.openSigninPopup = () ->
#             modalInstance = $modal.open(
#                 templateUrl: 'views/base/signinModal.html',
#                 controller: 'SigninPopupCtrl',
#             )
#
#         $rootScope.$watch('authVars.loginrequired', (newValue, oldValue) ->
#             console.log('loginRequired', newValue, oldValue)
#             if newValue == true
#                 $rootScope.openSigninPopup()
#
#         )
#
# module.factory('CurrentMakerScienceProfileService', ($rootScope, $modal, MakerScienceProfile) ->
#     return new CurrentMakerScienceProfileService($rootScope, $modal, MakerScienceProfile)
# )
#
#
# module.controller('SignupPopupCtrl', ($scope, $rootScope, $modalInstance, $state, User) ->
#     """
#     Controller bound to openSignupPopup method of CurrentMakerScienceProfile service
#     """
#     $scope.register = ->
#         $scope.user.email = $scope.user.username
#         User.post($scope.user).then((userResult) ->
#             $rootScope.authVars.username = $scope.user.username
#             $rootScope.authVars.password = $scope.user.password
#             $rootScope.loginService.submit()
#             $rootScope.$watch('currentMakerScienceProfile', (newValue, oldValue) ->
#                 if newValue != oldValue
#                     $modalInstance.close()
#                     $state.go("profile.detail", {slug : $rootScope.currentMakerScienceProfile.slug})
#
#             )
#         )
# )
#
# module.controller('SigninPopupCtrl', ($scope, $rootScope, $modalInstance) ->
#     $rootScope.$watch('authVars.isAuthenticated', (newValue, oldValue) ->
#         if newValue == true and oldValue== false
#             $modalInstance.close(null)
#     )
# )
