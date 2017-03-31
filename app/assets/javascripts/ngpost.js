(function(){
var appPost = angular.module("postApp", ['ngSanitize']);

appPost.controller("PostCtrl", ['$scope','$http', '$filter',  function ($scope, $http , $filter){
    $http.get('post_list').then(function successCallback(data) {
    $scope.posts = data.data;
    $scope.vote_limit = 5;
    console.log($scope.posts);    
  });

    $http.get('get_ip').then(function successCallback(data) {
    $scope.connect_ip = data.data[0].IP;
    console.log($scope.connect_ip);    
  });


    $scope.goodvote = function(post, idea){
    var path = "ngpost/" + post.id.toString() + "/add_vote.json";
    var senddata = [{'id': post.id, 'idea': idea }];
    
    $http.post(path, senddata ).then(function successCallback(data){
      console.log(data);
      console.log(data.data[0].goodvote);
      $scope.post.goodvote = data.data[0].goodvote;
      $scope.post.badvote = data.data[0].badvote;
      $scope.post.can_vote_tag = data.data[0].switch;
      if ($scope.post.can_vote_tag === true) {
      var vistor = "訪客 " + $scope.connect_ip;
      $scope.post.vote_records.push({created_at: new Date(),idea: idea.toString() ,name: vistor ,post_id: post.id});
    };
      
    });

 
  
  };  //goodvote end quote

  $scope.badvote = function(post, idea){
    var path = "ngpost/" + post.id.toString() + "/minus_vote.json";      
    var senddata = [{'id': post.id, 'idea': idea }];
    var warning_switch = false;

    $http.post(path, senddata ).then(function successCallback(data){
      console.log(data);
      console.log(data.data[0].goodvote);
      $scope.post.goodvote = data.data[0].goodvote;
      $scope.post.badvote = data.data[0].badvote;
      $scope.post.can_vote_tag = data.data[0].switch;
     if ($scope.post.can_vote_tag === true) {
     var vistor = "訪客 " + $scope.connect_ip;
     $scope.post.vote_records.unshift({created_at: new Date(),idea: idea.toString() ,name:  vistor ,post_id: post.id});
    };
    });

  };

}]);


appPost.controller("VoteController", ["$scope","$http", function($scope, $http){
 
  $scope.goodvote = function(post, idea){
    var path = "ngpost/" + post.id.toString() + "/add_vote.json";
    var senddata = [{'id': post.id, 'idea': idea }];
    
    $http.post(path, senddata ).then(function successCallback(data){
      console.log(data);
      console.log(data.data[0].goodvote);
      $scope.post.goodvote = data.data[0].goodvote;
      $scope.post.badvote = data.data[0].badvote;
      $scope.post.can_vote_tag = data.data[0].switch;
    });
    
    $scope.post.vote_records.unshift({created_at:"2017-04-01",idea:"1",ip:"59.127.199.25",name:"訪客 : 59.127.199.25",post_id: post.id});
  
  };

  $scope.badvote = function(post, idea){
    var path = "ngpost/" + post.id.toString() + "/minus_vote.json";      
    var senddata = [{'id': post.id, 'idea': idea }];
    var warning_switch = false;

    $http.post(path, senddata ).then(function successCallback(data){
      console.log(data);
      console.log(data.data[0].goodvote);
      $scope.post.goodvote = data.data[0].goodvote;
      $scope.post.badvote = data.data[0].badvote;
      $scope.post.can_vote_tag = data.data[0].switch;
    });
  };
  
}]);

appPost.filter('turntoicon', function(){
  var filter = function(input){
    if (input === "1"){
      return "<span class='glyphicon glyphicon-thumbs-up icon-thumbs-up ' aria-hidden='true'></span>";
    }
    else if (input === "-1"){
      return "<span class=\"glyphicon glyphicon-thumbs-down icon-thumbs-down \" aria-hidden=\"true\"></span>";  
    }
    else {
      return input;
    }
  };
  return filter;
});

})();