{if !MESSAGE_ENABLE_USER_CONSENT || ($__wcf->user->userID && $__wcf->user->getUserOption('enableEmbeddedMedia'))}
    {assign var='leafletHidden' value=false}
{else}
    {assign var='leafletHidden' value=true}
{/if}

<div 
    id="map{$leafletElementID}" 
    class="googleMap{if !$accessUserLocation|empty} access-user-location{/if}" 
    {if !$googleMapsZoom|empty}zoom="{$googleMapsZoom}"{/if} 
    {if !$googleMapsLat|empty}lat="{$googleMapsLat}"{/if}
    {if !$googleMapsLng|empty}lng="{$googleMapsLng}"{/if}
    {if !$googleMapsBounds|empty}bounds="{$googleMapsBounds}"{/if}
    {if $leafletHidden}hidden{/if}
    style="z-index: 0">
</div>

{if $leafletHidden}
    {if LEAFLET_DEFAULT_LAYER == 'openstreetmap'}
        {include file='messageUserConsent' host="tile.openstreetmap.org" url="https://tile.openstreetmap.org/" target='map'|concat:$leafletElementID sandbox=true}
    {elseif LEAFLET_DEFAULT_LAYER|str_starts_with:'topplus_open'}
        {include file='messageUserConsent' host="sgx.geodatenzentrum.de" url="http://www.bkg.bund.de/" target='map'|concat:$leafletElementID sandbox=true}
    {/if}
{/if}

{include file='leafletJavaScript'}
