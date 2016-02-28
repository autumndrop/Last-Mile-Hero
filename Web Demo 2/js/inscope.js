

L.mapbox.accessToken = 'pk.eyJ1Ijoic3lwZXJpb3VzIiwiYSI6ImNpZXo3cmpqNzExZGJzMG0zN3VwNXRzOWkifQ.cSFFxUOyQMXsZygJBrA6Cg';
var map = L.mapbox.map('map', 'mapbox.streets')
    .setView([38.8961,-77.0986],12)
    <!--.addLayer(L.mapbox.tileLayer('syperious.7e7c8c36'))-->
 .addControl(L.mapbox.geocoderControl('mapbox.places', {
        keepOpen: false,
	autocomplete: true
	}));	
	
; 
var fixedMarker = L.marker(new L.LatLng(38.8786192, -77.1123567), {
    icon: L.mapbox.marker.icon({
        'marker-color': '3366CC'
    })
}).bindPopup('Current Location').addTo(map);

var fixedMarker2 = L.marker(new L.LatLng(38.9065687, -77.041832), {
    icon: L.mapbox.marker.icon({
        'marker-color': 'CC3333'
    })
}).bindPopup('Destination').addTo(map);
 
 var layers = document.getElementById('menu-ui');
	
	
	



<!--add color scheme for the scores-->
function getColor(d) {
    return d > 850 ? '#CF4B00' :
           d > 800  ? '#CC5500' :
           d > 750  ? '#C95F00' :
           d > 700  ? '#C66900' :
           d > 650   ? '#C37300' :
           d > 600   ? '#C07D00' :
           d > 550  ? '#BD8700' :
           d > 500  ? '#BA9100' :
           d > 450   ? '#B79B00' :
           d > 400   ? '#B4A500' :
           d > 350   ? '#B1AF00' :
           d > 300   ? '#AEB900' :
           d > 250  ? '#ABC300' :
           d > 200  ? '#A8CD00' :
           d > 150   ? '#A5D700' :
           d > 100   ? '#A2E100' :
           d > 50   ? '#9FEB00' :
           d > 0   ? '#9CF500' :
                      '#c4c4c4';
}

function getBusColor(d)
 {
	 return d;
 }
//add function to grab colors for each hex grid
function hexStyle(feature) {
    return {
        fillColor: getColor(feature.properties.WeightedSu),
        weight: 2,
        opacity: 0.01,
        color: "white",
        fillOpacity: 0.7
    };
}

function MetroStyle(feature) {
    return {
        fillColor: "red",
        weight: 2.3,
        opacity: .7,
        color: "red",
        fillOpacity: 0.7
    };
}

function BusStyle(feature) {
    return {
        fillColor: "orange",
        weight: 1.8,
        opacity: .7,
        color: "orange",
        fillOpacity: 0.7
    };
}
//add geoJSON file


	
var exteriorStyle = {
    "weight": 0,
    "fillOpacity": .01
};	



var Bus_var =L.geoJson(dc_bus_routes,{
		style: BusStyle
});

var Metro_var =L.geoJson(dc_metro_routes,{
		style: MetroStyle
});

//addLayer(arable, 'geoJson', 4);

//addLayer(arable2, 'Hex + Interactive On/Off (geoJSON)', 5);
addLayer(Bus_var, 'Bus Routes', 6);
addLayer(Metro_var, 'Metro Routes', 7);





<!-- function for the mapbox layer selection menu-->
function addLayer(layer, name, zIndex) {
    layer
        .setZIndex(zIndex)
        .addTo(map);

    // Create a simple layer switcher that
    // toggles layers on and off.
    var link = document.createElement('a');
        link.href = '#';
        link.className = 'active';
        link.innerHTML = name;

    link.onclick = function(e) {
        e.preventDefault();
        e.stopPropagation();

        if (map.hasLayer(layer)) {
            map.removeLayer(layer);
            this.className = '';
        } else {
            map.addLayer(layer);
            this.className = 'active';
        }
    };

    layers.appendChild(link);
}
<!-- function for the mapbox layer selection menu END-->

<!--Scale control-->
L.control.scale().addTo(map);




