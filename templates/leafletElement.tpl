{if !MESSAGE_ENABLE_USER_CONSENT || ($__wcf->user->userID && $__wcf->user->getUserOption('enableEmbeddedMedia'))}
    {assign var='leafletHidden' value=false}
{else}
    {assign var='leafletHidden' value=true}
{/if}

<woltlab-core-leaflet 
    id='{$leafletElementID}' 
    class='googleMap' 
    defaulttile='{*
*}{if LEAFLET_DEFAULT_LAYER == 'openstreetmap'}{*
    *}{literal}https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png{/literal}{*
*}{elseif LEAFLET_DEFAULT_LAYER == 'topplus_open'}{*
    *}{literal}https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web/default/WEBMERCATOR/{z}/{y}/{x}.png{/literal}{*
*}{elseif LEAFLET_DEFAULT_LAYER == 'topplus_open_grau'}{*
    *}{literal}https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web_grau/default/WEBMERCATOR/{z}/{y}/{x}.png{/literal}{*
*}{elseif LEAFLET_DEFAULT_LAYER == 'topplus_open_light'}{*
    *}{literal}https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web_light/default/WEBMERCATOR/{z}/{y}/{x}.png{/literal}{*
*}{elseif LEAFLET_DEFAULT_LAYER == 'topplus_open_light_grau'}{*
    *}{literal}https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web_light_grau/default/WEBMERCATOR/{z}/{y}/{x}.png{/literal}{*
*}{else}{*
    *}{LEAFLET_CUSTOM_LAYER_LINK}{*
*}{/if}' 
    defaulttilecopy='wcf.global.leaflet.copy.{LEAFLET_DEFAULT_LAYER}' 
    zoom='{if !$googleMapsZoom|empty}{$googleMapsZoom}{else}{GOOGLE_MAPS_ZOOM}{/if}' 
	lat='{if !$googleMapsLat|empty}{$googleMapsLat}{else}{GOOGLE_MAPS_DEFAULT_LATITUDE}{/if}' 
	lng='{if !$googleMapsLng|empty}{$googleMapsLng}{else}{GOOGLE_MAPS_DEFAULT_LONGITUDE}{/if}' 
    {if !$googleMapsBounds|empty}bounds='{$googleMapsBounds}' {/if}
    {if $leafletHidden}hidden {/if}
    {if !$accessUserLocation|empty}access-user-location {/if}
    style='z-index: 0'>
</woltlab-core-leaflet>

{if $leafletHidden}
    {if LEAFLET_DEFAULT_LAYER == 'openstreetmap'}
        {include file='messageUserConsent' host='tile.openstreetmap.org' url='https://tile.openstreetmap.org/' target=$leafletElementID sandbox=true}
    {elseif LEAFLET_DEFAULT_LAYER|str_starts_with:'topplus_open'}
        {include file='messageUserConsent' host='sgx.geodatenzentrum.de' url='http://www.bkg.bund.de/' target=$leafletElementID sandbox=true}
    {else}
        {include file='messageUserConsent' host="{LEAFLET_CUSTOM_LAYER_HOST}" url="{LEAFLET_CUSTOM_LAYER_URL}" target=$leafletElementID sandbox=true}
    {/if}
{/if}

{include file='leafletJavaScript'}
