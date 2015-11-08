var config = require('./config/main');
var Retsly = require('js-sdk');
var GooglePlacesPromises = require('googleplaces-promises');
var rp = require('request-promise');

module.exports = function(app) {
    // server routes ===========================================================
    app.get('/api', function(req, res) {
        res.json({msg: 'Hello world!'}); 
    });
    
    app.get('/api/listings', function(req, res) {
        var lat = req.param('lat', config.default.coordinates.lat);
        var lon = req.param('lon', config.default.coordinates.lon);
        var retsly_radius = req.param('retsly_radius', config.Retsly.defaultRadius);
        var google_radius = req.param('google_radius', config.Google.defaultRadius);
        var types = req.param('types', config.Google.defaultTypes);
        var limit = req.param('limit', config.default.requestLimitItems);
        
        // Final return object
        var returnData = {};
        
        // Options for Retsly request API
        var retslyRequestOptions = {
            uri: config.Retsly.baseUrl + config.Retsly.Dataset + '/listings?access_token=' + config.Retsly.Token,
            qs: {
                limit: limit,
                near: lon + ',' + lat,
                radius: retsly_radius
            },
            json: true 
        };
        
        // Google Places API object
        var googlePlacesPromises = new GooglePlacesPromises(config.Google.apiKey, config.Google.outputFormat);
        
        // Google Places search parameters
        var googleSearchMainParams = {
            location: [lat, lon],
            radius: google_radius,
            types: types
        };
        
        console.log("Retsly searching location = " + lat + "," + lon + " / Radius = " + retsly_radius + " / Limit = " + limit);
        
        // Promises
        rp(retslyRequestOptions)
            .then(function (data) {
                returnData.listings = data.bundle;
                
                console.log("Google searching location = " + googleSearchMainParams.location + " / Radius = " + google_radius + " / Types = " + types);
                
                // Chain promises
                return googlePlacesPromises.placeSearch(googleSearchMainParams);
            })
            .then(function (data) {
                returnData.nearBy = data.results;
                
                // Response to the client!
                res.json(returnData);
            })
            .catch(function (err) {
                console.log('Error: ' + err);
            });
    });
    
    app.get('/api/retsly/listings', function(req, res) {
        var lat = req.param('lat', config.default.coordinates.lat);
        var lon = req.param('lon', config.default.coordinates.lon);
        var radius = req.param('radius', config.Retsly.defaultRadius);
        var limit = req.param('limit', config.default.requestLimitItems);
        
        var retsly = Retsly.create(config.Retsly.Token, config.Retsly.Dataset);
        
        var retslyRequest = retsly.listings()
                            .query({near: lat + ',' + lon})
                            .query({radius: radius})
                            .limit(limit);
        
        console.log("Retsly searching location = " + lat + "," + lon + " / Radius = " + radius);
        
        retslyRequest.getAll(function(err, data) {
            if (err) throw err;
            res.json(data); 
        });
    });
    
    app.get('/api/retsly/agent', function(req, res) {
        var agentId = req.param('id', 0);
        if (!agentId) {
            res.json({error: 'no agent informed!'});
        }

        var retsly = Retsly.create(config.Retsly.Token, config.Retsly.Dataset);
        
        var retslyRequest = retsly.agents();
        
        console.log("Retsly getting agent = " + agentId);
        
        retslyRequest.get(agentId, function(err, data) {
            if (err) throw err;
            res.json(data.bundle);
        });
    });
    
    app.get('/api/retsly/listing', function(req, res) {
        var listingId = req.param('id', 0);
        if (!listingId) {
            res.json({error: 'no listing informed!'});
        }

        var retsly = Retsly.create(config.Retsly.Token, config.Retsly.Dataset);
        
        var retslyRequest = retsly.listings();
        
        console.log("Retsly getting listing = " + listingId);
        
        retslyRequest.get(listingId, function(err, data) {
            if (err) throw err;
            res.json(data.bundle);
        });
    });
    
    app.get('/api/google/nearby', function(req, res) {
        var lat = req.param('lat', config.default.coordinates.lat);
        var lon = req.param('lon', config.default.coordinates.lon);
        var radius = req.param('radius', config.Google.defaultRadius);
        var types = req.param('types', config.Google.defaultTypes);
        
        var placesPromises = new GooglePlacesPromises(config.Google.apiKey, config.Google.outputFormat);
                 
        var searchParams = {
            location: [lat, lon],
            radius: radius,
            types: types
        };
        
        console.log("Google searching location = " + searchParams.location + " / Radius = " + radius + " / Types = " + types);
        
        var placeSearch = placesPromises.placeSearch(searchParams);
         
        placeSearch
            .then(function(response){
                res.json(response)
            })
            .fail(function(error){
                throw error;
            });
    });
    
    app.get('/api/google/place', function(req, res) {
        var place_id = req.param('id', 0);
        if (!place_id) {
            res.json({error: 'no place informed!'});
        }

        var placesPromises = new GooglePlacesPromises(config.Google.apiKey, config.Google.outputFormat);
                 
        var searchParams = {
            placeid: place_id
        };
        
        console.log("Google searching place id = " + place_id);
        
        var placeDetails = placesPromises.placeDetailsRequest(searchParams);
         
        placeDetails
            .then(function(response){
                res.json(response.result)
            })
            .fail(function(error){
                throw error;
            });
    });

    // frontend routes =========================================================
    // route to handle all angular requests
    app.get('*', function(req, res) {
        res.sendfile('./public/index.html'); // load our public/index.html file
    });
};