// Generated by CoffeeScript 1.10.0
(function() {
  var module;

  module = angular.module("map.controllers", []);

  module.run([
    '$anchorScroll', function($anchorScroll) {
      return $anchorScroll.yOffset = 50;
    }
  ]);

  module.controller("ImaginationProjectsMapCtrl", function($scope, $compile, $anchorScroll, $timeout, $location, leafletData, leafletEvents, geocoderService, Project, ProjectSheet) {
    "This controller is made to be child of ProjectListCtrl where it watches for update in $scope.projectsheets list\nUpon update, it rebuilds its marker base";
    $scope.rebuildMarkers = function() {
      var cluster_group_name;
      console.log(" Updating marker");
      $scope.markers = new Array();
      cluster_group_name = Math.random().toString(36).replace(/[^a-z]+/g, '').substr(0, 5);
      return angular.forEach($scope.projectsheets, function(ps) {
        var marker, marker_data;
        if (ps.project.location) {
          if (ps.project.location.geo) {
            marker_data = {
              title: ps.project.title,
              baseline: ps.project.baseline,
              description: ps.project.description,
              cover: ps.cover,
              id: ps.project.id,
              slug: ps.project.slug
            };
            marker = {
              group: cluster_group_name,
              groupOption: {
                showCoverageOnHover: false
              },
              lat: ps.project.location.geo.coordinates[1],
              lng: ps.project.location.geo.coordinates[0],
              getMessageScope: function() {
                var newScope;
                newScope = $scope.$new();
                angular.extend(newScope, {
                  marker: {
                    data: marker_data
                  }
                });
                return newScope;
              },
              message: '<div ng-include="\'views/map/marker_card.html\'" class="boxes boxes-small"></div>',
              icon: {
                type: 'awesomeMarker',
                prefix: 'fa',
                markerColor: "blue",
                iconColor: "white"
              }
            };
            return $scope.markers.push(marker);
          }
        }
      });
    };
    $scope.gotoAnchor = function(x) {
      var newHash;
      newHash = 'anchor' + x;
      if ($location.hash() !== newHash) {
        return $location.hash('anchor' + x);
      } else {
        return $anchorScroll();
      }
    };
    console.log("loadind map, projectsheets ?", $scope.projectsheets);
    angular.extend($scope, {
      defaults: {
        scrollWheelZoom: true,
        maxZoom: 14,
        minZoom: 1,
        path: {
          weight: 10,
          color: '#800000',
          opacity: 1
        }
      },
      center: {
        lat: 46.43,
        lng: 2.35,
        zoom: 5
      },
      markers: []
    });
    $scope.cluster_group_name = Math.random().toString(36).replace(/[^a-z]+/g, '').substr(0, 5);
    $scope.rebuildMarkers();
    return $scope.$on('projectListRefreshed', function(event) {
      return $scope.rebuildMarkers();
    });
  });

}).call(this);
