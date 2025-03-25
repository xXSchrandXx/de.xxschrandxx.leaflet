{include file='header'}

<p>Map1: Default coordinates</p>
{include file='leafletElement' leafletElementID=1}
<br>
<p>Map2: Custom coordinates</p>
{include file='leafletElement' leafletElementID=2 googleMapsLat=48.400002 googleMapsLng=9.983333}
{assign var='googleMapsLat' value=null}
{assign var='googleMapsLng' value=null}
<br>
<p>Map3: Access user location</p>
{include file='leafletElement' leafletElementID=3 accessUserLocation=true}
{assign var='accessUserLocation' value=null}
<br>
<p>Map4: Bounds</p>
{include file='leafletElement' leafletElementID=4 googleMapsBounds='[[45.4, 9.98], [45.41, 9.99]]' googleMapsLat=48.400002 googleMapsLng=9.983333}
{assign var='googleMapsBounds' value=null}
{assign var='googleMapsLat' value=null}
{assign var='googleMapsLng' value=null}

{include file='footer'}
