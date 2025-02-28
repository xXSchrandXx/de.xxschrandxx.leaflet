{if !MESSAGE_ENABLE_USER_CONSENT || ($__wcf->user->userID && $__wcf->user->getUserOption('enableEmbeddedMedia'))}
    {assign var='openStreetMapsHidden' value=false}
{else}
    {assign var='openStreetMapsHidden' value=true}
{/if}

<div 
    id="map{$openStreetMapsElementID}" 
    class="googleMap" 
    zoom="{GOOGLE_MAPS_ZOOM}" 
    {if $openStreetMapsElements[$openStreetMapsElementID]['style']|isset && !$openStreetMapsElements[$openStreetMapsElementID]['style']|empty}style="{$openStreetMapsElements[$openStreetMapsElementID]['style']}" {/if}
    {if $openStreetMapsElements[$openStreetMapsElementID]['hidden']|isset && $openStreetMapsElements[$openStreetMapsElementID]['hidden']}hidden{/if}>
</div>

<link rel="stylesheet" href="{@$__wcf->getPath()}js/3rdParty/leaflet/leaflet.css" />
<script data-relocate="true">
    require(['3rdParty/leaflet/leaflet'], function(L) {
            var map{$openStreetMapsElementID} = L.map('map{$openStreetMapsElementID}').setView([
            {$openStreetMapsElements[$openStreetMapsElementID]['lat']},
            {$openStreetMapsElements[$openStreetMapsElementID]['lng']}
        ], {GOOGLE_MAPS_ZOOM});

        {*
        L.tileLayer('https://{ldelim}s{rdelim}.tile.openstreetmap.org/{ldelim}z{rdelim}/{ldelim}x{rdelim}/{ldelim}y{rdelim}.png', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
        }).addTo(map{$openStreetMapsElementID});
        *}

        L.tileLayer('https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web_light_grau/default/WEBMERCATOR/{ldelim}z{rdelim}/{ldelim}y{rdelim}/{ldelim}x{rdelim}.png', {
            attribution: '&copy; <a href="http://www.bkg.bund.de/">Bundesamt für Kartographie und Geodäsie ({time time=TIME_NOW type='custom' format='Y'})</a>'
        }).addTo(map{$openStreetMapsElementID});

        {foreach from=$openStreetMapsElements[$openStreetMapsElementID]['marker'] item=marker}
            L.marker([{$marker['lat']}, {$marker['lng']}]).addTo(map{$openStreetMapsElementID})
                {if $marker['popup']|isset}.bindPopup('{$marker['popup']}'){/if}
                {if $marker['open']|isset && $marker['open']}.openPopup(){/if}
                ;
        {/foreach}
    });
</script>

{if $openStreetMapsHidden}
    {*
    {include file='messageUserConsent' host="tile.openstreetmap.org" url="https://tile.openstreetmap.org/" target='map'|concat:$openStreetMapsElementID sandbox=true}
    *}
    {include file='messageUserConsent' host="sgx.geodatenzentrum.de" url="http://www.bkg.bund.de/" target='map'|concat:$openStreetMapsElementID sandbox=true}
{/if}
