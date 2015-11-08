angular.module('appRoutes', []).config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {

    $routeProvider

        // home page
        .when('/', {
            templateUrl: 'views/home.html',
            controller: 'MainController'
        })

        // hello world!
        .when('/helloworld', {
            templateUrl: 'views/helloworld.html',
            controller: 'HelloWorldController'
        });

    $locationProvider.html5Mode(true);

}]);