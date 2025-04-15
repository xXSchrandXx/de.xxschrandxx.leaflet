{if LEAFLET_REPLACE_GOOGLEMAPS}
    <script data-relocate="true">
        require(["xXSchrandXx/Core/Component/Leaflet/GoogleMapsReplace"], function(r) {
            r.r("{LEAFLET_DEFAULT_LAYER}", 'wcf.global.leaflet.copy.{LEAFLET_DEFAULT_LAYER}', {LEAFLET_DEFAULT_CONNECTION}, "{LEAFLET_CUSTOM_LAYER_URLTEMPLATE}");
        });
        {event name='replaceGoogleMapsScript'}
    </script>
    {event name='replaceGoogleMaps'}
{/if}
