{if LEAFLET_REPLACE_GOOGLEMAPS}
	{include file='leafletJavaScript'}

	<script data-relocate="true">
		require(["xXSchrandXx/Core/Component/Leaflet/GoogleMapsReplace"], function(r) {
			r.r("{LEAFLET_DEFAULT_LAYER|encodeJS}", 'wcf.global.leaflet.copy.{LEAFLET_DEFAULT_LAYER|encodeJS}', {LEAFLET_DEFAULT_CONNECTION|encodeJS}, "{LEAFLET_CUSTOM_LAYER_URLTEMPLATE|encodeJS}");
		});
		{event name='replaceGoogleMapsScript'}
	</script>
	{event name='replaceGoogleMaps'}
{/if}
