var gemapp = angular.module('store-directives', []);

gemapp.directive("descriptions", function() {
  return {
    restrict: "E",
    templateUrl: "descriptions.html"
  }
});

gemapp.directive("reviews", function() {
  return {
    restrict: "E",
    templateUrl: "reviews.html"
  }
});

gemapp.directive("specs", function() {
  return {
    restrict: "E",
    templateUrl: "specs.html"
  }
});

gemapp.directive("productTabs", function() {
  return {
    restrict: "E",

    templateUrl: "product-tabs.html",
    controller: function() {
      this.tab = 1;

      this.isSet = function(checkTab) {
        return this.tab === checkTab;
      };

      this.setTab = function(activeTab) {
        this.tab = activeTab;
      };
    },
    controllerAs: "tab"
  };
});
