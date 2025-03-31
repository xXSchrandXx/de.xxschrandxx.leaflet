{if LEAFLET_DEFAULT_LAYER == 'openstreetmap'}
    {assign var=defaulttile value='{literal}https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png{/literal}'}
{elseif LEAFLET_DEFAULT_LAYER == 'topplus_open'}
    {assign var=defaulttile value='{literal}https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web/default/WEBMERCATOR/{z}/{y}/{x}.png{/literal}'}
{elseif LEAFLET_DEFAULT_LAYER == 'topplus_open_grau'}
    {assign var=defaulttile value='{literal}https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web_grau/default/WEBMERCATOR/{z}/{y}/{x}.png{/literal}'}
{elseif LEAFLET_DEFAULT_LAYER == 'topplus_open_light'}
    {assign var=defaulttile value='{literal}https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web_light/default/WEBMERCATOR/{z}/{y}/{x}.png{/literal}'}
{elseif LEAFLET_DEFAULT_LAYER == 'topplus_open_light_grau'}
    {assign var=defaulttile value='{literal}https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web_light_grau/default/WEBMERCATOR/{z}/{y}/{x}.png{/literal}'}
{else}
    {assign var=defaulttile value=LEAFLET_CUSTOM_LAYER_LINK}
{/if}
<script data-relocate="true">
    require(["xXSchrandXx/Core/Component/Leaflet/GoogleMapsReplace"], function(r) {
        r.r('{$defaulttile}', '{jslang}wcf.global.leaflet.copy.{LEAFLET_DEFAULT_LAYER}{/jslang}');
    });
    {event name='replaceGoogleMapsScript'}
</script>
{event name='replaceGoogleMaps'}
