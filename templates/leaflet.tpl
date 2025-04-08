{include file='header'}

<p>Map1: Default coordinates</p>
{include file='leafletElement' leafletElementID=1}
<br>
<p>Map2: Custom coordinates</p>
{include file='leafletElement' defaultTile='topplus_open_light_grau' leafletElementID=2 googleMapsLat=48.400002 googleMapsLng=9.983333}
{assign var='defaultTile' value=null}
{assign var='googleMapsLat' value=null}
{assign var='googleMapsLng' value=null}
<br>
<p>Map3: Access user location</p>
{include file='leafletElement' tileconnectdirect=true leafletElementID=3 accessUserLocation=true}
{assign var='tileconnectdirect' value=null}
{assign var='accessUserLocation' value=null}
<br>
<p>Map4: Bounds</p>
{include file='leafletElement' leafletElementID=4 googleMapsBounds='{literal}{"southWest": {"latitude": 45.4, "longitude": 9.98}, "northEast": {"latitude": 45.41, "longitude": 9.99}}{/literal}'}
{assign var='googleMapsBounds' value=null}
{assign var='googleMapsLat' value=null}
{assign var='googleMapsLng' value=null}
<br>
<p>Map5: Googlemaps</p>
{include file='googleMapsElement' googleMapsElementID=4 googleMapsBounds='{literal}{"southWest": {"latitude": 45.4, "longitude": 9.98}, "northEast": {"latitude": 45.41, "longitude": 9.99}}{/literal}'}

<script data-relocate="true">
require(["xXSchrandXx/Core/Component/Leaflet/Marker"], function(M) {
    // Map1
    M.addDraggableMarker(document.getElementById('1'));

    // Map2
    M.addMarker(document.getElementById('2'), 48.400002, 9.983333, 'Title', 'Description');

    // Map3
    M.addMarker(document.getElementById('3'), 48.400002, 9.983333, 'Title', 'Description');

    // Map4
    M.addMarker(document.getElementById('4'), 48.400002, 9.983333, 'Title', 'Description');
});
</script>

{include file='footer'}
