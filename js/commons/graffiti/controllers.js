// Generated by CoffeeScript 1.10.0
(function() {
  var module;

  module = angular.module("commons.graffiti.controllers", ['commons.graffiti.services']);

  module.controller("TagListCtrl", function($scope, Tag) {
    return $scope.tags = Tag.getList().$object;
  });

  module.controller("TagAutoCompleteCtrl", function($scope, $q, Tag) {
    var tags;
    tags = Tag.getList();
    return $scope.loadTags = function(query) {
      var availableTags, deferred;
      deferred = $q.defer();
      availableTags = [];
      angular.forEach(tags.$object, function(tag) {
        var tmpTag;
        tag.name = tag.name.toLowerCase();
        query = query.toLowerCase();
        if (tag.name.indexOf(query) > -1) {
          tmpTag = {
            'text': tag.name
          };
          return availableTags.push(tmpTag);
        }
      });
      deferred.resolve(availableTags);
      return deferred.promise;
    };
  });

  module.controller("TaggedItemCtrl", function($scope, $stateParams, $modal, Tag, TaggedItem) {
    $scope.taggedItems = [];
    $scope.tag = null;
    if ($stateParams.slug) {
      Tag.one().get({
        slug: $stateParams.slug
      }).then(function(tagResult) {
        $scope.tag = tagResult.objects[0];
        if ($scope.tag && $scope.tag.weight > 0) {
          return $scope.taggedItems = TaggedItem.getList({
            'tag__slug': $stateParams.slug
          }).$object;
        }
      });
    }
    $scope.addTag = function(objectTypeName, resourceId, tag) {
      var tag_text;
      tag_text = tag.text;
      tag_text = tag_text.toLowerCase();
      tag_text = tag_text.replace(/\//i, "-");
      tag.text = tag_text;
      return TaggedItem.one().customPOST({
        tag: tag_text
      }, objectTypeName + "/" + resourceId, {});
    };
    $scope.removeTag = function(tag) {
      return TaggedItem.one(tag.taggedItemId).remove();
    };
    return $scope.openTagPopup = function(editTag, taggedObject, taggedObjectTypeName) {
      var modalInstance;
      return modalInstance = $modal.open({
        templateUrl: 'views/catalog/block/modal_tags.html',
        controller: 'TagPopupCtrl',
        size: 'lg',
        resolve: {
          params: function() {
            return {
              preparedTags: $scope.preparedTags,
              editTag: editTag,
              objectTypeName: taggedObjectTypeName,
              taggedObject: taggedObject,
              addTag: $scope.addTag,
              removeTag: $scope.removeTag
            };
          }
        }
      });
    };
  });

  module.controller('TagPopupCtrl', function($scope, $modalInstance, params) {
    $scope.preparedTags = params.preparedTags;
    $scope.editTag = params.editTag;
    if ($scope.editTag) {
      $scope.objectTypeName = params.objectTypeName;
      $scope.taggedObject = params.taggedObject;
      $scope.addTag = params.addTag;
      $scope.removeTag = params.removeTag;
    }
    $scope.ok = function() {
      return $modalInstance.close();
    };
    return $scope.cancel = function() {
      return $modalInstance.dismiss('cancel');
    };
  });

}).call(this);