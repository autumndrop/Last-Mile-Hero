
// Uber API Constants
var uberClientId = "hRY8QT3rX7xhJFIDraLCIE1Ll4qSQxwS"
  , uberServerToken = "Yjyw44AQBE-86J2RbG3dJegJfW--0A4RxgICy-HA";

// create placeholder variables
var userLatitude
  , userLongitude
  , partyLatitude = 38.8961
  , partyLongitude = -77.0986;

navigator.geolocation.watchPosition(function(position) {
	console.log(position);
    // Update latitude and longitude
    userLatitude = position.coords.latitude;
    userLongitude = position.coords.longitude;
});// JavaScript Document

  // Query Uber API if needed
    getEstimatesForUserLocation(userLatitude, userLongitude);


function getEstimatesForUserLocation(latitude,longitude) {
  $.ajax({
	url: "https://api.uber.com/v1/estimates/price",
	headers: {
		Authorization: "Token " + uberServerToken
	},
	data: {
		start_latitude: latitude,
		start_longitude: longitude,
		end_latitude: partyLatitude,
		end_longitude: partyLongitude
	},
	success: function(result) {
		console.log(result);
	}
  });
}
