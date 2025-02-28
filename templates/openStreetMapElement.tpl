{if !MESSAGE_ENABLE_USER_CONSENT || ($__wcf->user->userID && $__wcf->user->getUserOption('enableEmbeddedMedia'))}
    {assign var='openStreetMapsHidden' value=false}
{else}
    {assign var='openStreetMapsHidden' value=true}
{/if}

<div 
    id="map{$openStreetMapsElementID}" 
    class="googleMap" 
    zoom="{GOOGLE_MAPS_ZOOM}" 
    style="z-index: 0{if $openStreetMapsElements[$openStreetMapsElementID]['style']|isset && !$openStreetMapsElements[$openStreetMapsElementID]['style']|empty}; {$openStreetMapsElements[$openStreetMapsElementID]['style']}{/if}"
    {if $openStreetMapsElements[$openStreetMapsElementID]['hidden']|isset && $openStreetMapsElements[$openStreetMapsElementID]['hidden']}hidden{/if}>
</div>

<link rel="stylesheet" href="{@$__wcf->getPath()}js/3rdParty/leaflet/leaflet.css" />
<script data-relocate="true">
    require(['3rdParty/leaflet/leaflet'], function(L) {
        var osm = L.tileLayer('https://{ldelim}s{rdelim}.tile.openstreetmap.org/{ldelim}z{rdelim}/{ldelim}x{rdelim}/{ldelim}y{rdelim}.png', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
        });

        var web = L.tileLayer('https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web/default/WEBMERCATOR/{ldelim}z{rdelim}/{ldelim}y{rdelim}/{ldelim}x{rdelim}.png', {
            attribution: '&copy; <a href="http://www.bkg.bund.de/">Bundesamt für Kartographie und Geodäsie ({time time=TIME_NOW type='custom' format='Y'})</a>'
        });
        var web_grau = L.tileLayer('https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web_grau/default/WEBMERCATOR/{ldelim}z{rdelim}/{ldelim}y{rdelim}/{ldelim}x{rdelim}.png', {
            attribution: '&copy; <a href="http://www.bkg.bund.de/">Bundesamt für Kartographie und Geodäsie ({time time=TIME_NOW type='custom' format='Y'})</a>'
        });
        var web_light = L.tileLayer('https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web_light/default/WEBMERCATOR/{ldelim}z{rdelim}/{ldelim}y{rdelim}/{ldelim}x{rdelim}.png', {
            attribution: '&copy; <a href="http://www.bkg.bund.de/">Bundesamt für Kartographie und Geodäsie ({time time=TIME_NOW type='custom' format='Y'})</a>'
        });
        var web_light_grau = L.tileLayer('https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web_light_grau/default/WEBMERCATOR/{ldelim}z{rdelim}/{ldelim}y{rdelim}/{ldelim}x{rdelim}.png', {
            attribution: '&copy; <a href="http://www.bkg.bund.de/">Bundesamt für Kartographie und Geodäsie ({time time=TIME_NOW type='custom' format='Y'})</a>'
        });

        var map{$openStreetMapsElementID} = L.map('map{$openStreetMapsElementID}', {
            center: [{$openStreetMapsElements[$openStreetMapsElementID]['lat']}, {$openStreetMapsElements[$openStreetMapsElementID]['lng']}],
            zoom: {GOOGLE_MAPS_ZOOM},
            layers: [web_light_grau]
        });

        var layerControl = L.control.layers({
            "OpenStreetMap": osm,
            "TopPlusOpen": web,
            "TopPlusOpen Grau": web_grau,
            "TopPlusOpen Light": web_light,
            "TopPlusOpen Light Grau": web_light_grau
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
    {include file='messageUserConsent' host="tile.openstreetmap.org" url="https://tile.openstreetmap.org/" target='map'|concat:$openStreetMapsElementID sandbox=true}
    {include file='messageUserConsent' host="sgx.geodatenzentrum.de" url="http://www.bkg.bund.de/" target='map'|concat:$openStreetMapsElementID sandbox=true}
{/if}
