var app = angular.module('HelloWorldController', ['uiGmapgoogle-maps']);

app.controller('HelloWorldController', function($scope, GetResult) {
    $scope.tagline = 'Hello World Sritam and Phil!';
    $scope.map = { center: { latitude: 37.7887200, longitude: -122.3983840 }, zoom: 20 };
    
    GetResult.retrieveData(31.544275, -110.2365725, function(data){
    		$scope.listings = (data.data.bundle);
			console.log(data.data.bundle);
    	});
})

.service('GetResult', ['$http', function($http){
	return{
		"retrieveData": function(lat, long, callback){
		    var endPoint = '/api/retsly/listings?lat=' + lat + '&lon=' + long + '&radius=5km';
		    
			$http({
		        method: 'GET',
		        url: endPoint
		      }).then(callback, function errorCallback(response) { console.log('Failure');
		     });
		}
	}
}])