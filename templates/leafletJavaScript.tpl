{if !$__leafletInit|isset}
	{assign var=__leafletInit value=1}

    <link rel="stylesheet" href="{@$__wcf->getPath()}js/3rdParty/leaflet/leaflet.css" />
    <script data-relocate="true">
        document.addEventListener('DOMContentLoaded', () => {
            require(['3rdParty/leaflet/leaflet'], function(L) {
                document.querySelectorAll('.googleMap').forEach((mapElement) => {
                    var mapId = mapElement.id;
                    var lat = mapElement.getAttribute('lat');
                    var lng = mapElement.getAttribute('lng');
                    var zoom = mapElement.getAttribute('zoom');
                    var bounds = mapElement.getAttribute('bounds');
                    var accessUserLocation = mapElement.classList.contains('access-user-location');
                    console.log('Loading ' + mapId + '...\n  lat: ' + lat + '\n  lng: ' + lng + '\n  zoom: ' + zoom + '\n  bounds: ' + bounds + '\n  accessUserLocation: ' + accessUserLocation);

                    var defaultTile = null;
                    switch ('{LEAFLET_DEFAULT_LAYER}') {
                        case 'openstreetmap':
                            defaultTile = L.tileLayer('https://{ldelim}s{rdelim}.tile.openstreetmap.org/{ldelim}z{rdelim}/{ldelim}x{rdelim}/{ldelim}y{rdelim}.png', {
                                attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
                            });
                            break;
                        case 'topplus_open':
                            defaultTile = L.tileLayer('https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web/default/WEBMERCATOR/{ldelim}z{rdelim}/{ldelim}y{rdelim}/{ldelim}x{rdelim}.png', {
                                attribution: '&copy; <a href="http://www.bkg.bund.de/">Bundesamt für Kartographie und Geodäsie ({time time=TIME_NOW type='custom' format='Y'})</a>'
                            });
                            break;
                        case 'topplus_open_grau':
                            defaultTile = L.tileLayer('https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web_grau/default/WEBMERCATOR/{ldelim}z{rdelim}/{ldelim}y{rdelim}/{ldelim}x{rdelim}.png', {
                                attribution: '&copy; <a href="http://www.bkg.bund.de/">Bundesamt für Kartographie und Geodäsie ({time time=TIME_NOW type='custom' format='Y'})</a>'
                            });
                            break;
                        case 'topplus_open_light':
                            defaultTile = L.tileLayer('https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web_light/default/WEBMERCATOR/{ldelim}z{rdelim}/{ldelim}y{rdelim}/{ldelim}x{rdelim}.png', {
                                attribution: '&copy; <a href="http://www.bkg.bund.de/">Bundesamt für Kartographie und Geodäsie ({time time=TIME_NOW type='custom' format='Y'})</a>'
                            });
                            break;
                        case 'topplus_open_light_grau':
                            defaultTile = L.tileLayer('https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web_light_grau/default/WEBMERCATOR/{ldelim}z{rdelim}/{ldelim}y{rdelim}/{ldelim}x{rdelim}.png', {
                                attribution: '&copy; <a href="http://www.bkg.bund.de/">Bundesamt für Kartographie und Geodäsie ({time time=TIME_NOW type='custom' format='Y'})</a>'
                            });
                            break;
                        default:
                            if (LEAFLET_CUSTOM_LAYER_LINK == null || empty(LEAFLET_CUSTOM_LAYER_LINK)) break;
                            defaultTile = L.tileLayer('{LEAFLET_CUSTOM_LAYER_LINK}', {LEAFLET_CUSTOM_LAYER_OPTIONS});
                            break;
                    }

                    if (defaultTile == null) {
                        console.error('No valid tile layer for map with id ' + mapId);
                        return;
                    }

                    var map = L.map(mapElement);
                    map = map.addLayer(defaultTile);
                    map = map.setView([{GOOGLE_MAPS_DEFAULT_LATITUDE}, {GOOGLE_MAPS_DEFAULT_LONGITUDE}], {GOOGLE_MAPS_ZOOM});
                    if (accessUserLocation) {
                        map = map.locate({literal}{setView: true}{/literal});
                    } else if (bounds != null)  {
                        map = map.fitBounds(bounds);
                    } else if (lat != null && lng != null) {
                        map = map.panTo(L.latLng(lat, lng));
                    } else {
                        console.error('No valid coordinates provided for map with id ' + mapId);
                    }
                    if (zoom != null) {
                        map = map.setZoom(zoom);
                    }
                    if (lat != null && lng != null) {
                        L.marker([lat, lng]).addTo(map);
                    } else if (accessUserLocation) {
                        L.marker([map.getCenter().lat, map.getCenter().lng]).addTo(map);
                    }
                });
            });
        });
    </script>
{/if}
