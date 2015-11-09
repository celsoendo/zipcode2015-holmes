module.exports = {
    // Default config
    'default': {
        'coordinates': {
            'lat': '33.424303',
            'lon': '-111.929040'
        },
        'requestLimitItems': 20
    },
    
    // Retsly API config
    'Retsly': {
        'Token': 'd198cc003f1af3517db69cdf28c90979',
        //'Dataset': 'armls',
        'Dataset': 'test_sf',
        'defaultRadius': '5km',
        'baseUrl': 'https://rets.io/api/v1/'
    },
    
    // Google API config
    'Google': {
        'apiKey': process.env.GOOGLE_PLACES_API_KEY || "AIzaSyAuyLVinCv8X2HxVabVq5xpj3efJT2-HSw",
        'outputFormat': process.env.GOOGLE_PLACES_OUTPUT_FORMAT || "json",
        'defaultTypes': 'church|school|hospital|restaurant|bank',
        'defaultRadius': 5000
    }
};