angular.module('HelloWorldService', []).factory('HelloWorld', ['$http', function($http) {

    return {
        get : function() {
            return $http.get('/api');
        },
    }       

}]);