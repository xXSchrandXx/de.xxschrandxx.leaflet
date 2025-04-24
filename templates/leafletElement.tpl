{* Set default values *}
{if !$defaultTile|isset || $defaultTile|empty}
	{assign var='defaultTile' value=LEAFLET_DEFAULT_LAYER}
{/if}
{if !$googleMapsZoom|isset || $googleMapsZoom|empty}
	{assign var='googleMapsZoom' value=GOOGLE_MAPS_ZOOM}
{/if}
{if !$googleMapsLat|isset || $googleMapsLat|empty}
	{assign var='googleMapsLat' value=GOOGLE_MAPS_DEFAULT_LATITUDE}
{/if}
{if !$googleMapsLng|isset || $googleMapsLng|empty}
	{assign var='googleMapsLng' value=GOOGLE_MAPS_DEFAULT_LONGITUDE}
{/if}
{if !$tileconnectdirect|isset}
	{assign var='tileconnectdirect' value=LEAFLET_DEFAULT_CONNECTION}
{/if}

{* Check weather hidden *}
{if $tileconnectdirect}
	{if !MESSAGE_ENABLE_USER_CONSENT || ($__wcf->user->userID && $__wcf->user->getUserOption('enableEmbeddedMedia'))}
		{assign var='leafletHidden' value=false}
	{else}
		{assign var='leafletHidden' value=true}
	{/if}
{else}
	{assign var='leafletHidden' value=false}
{/if}

<woltlab-core-leaflet 
	id={$leafletElementID|encodeJS} 
	class='googleMap' 
	defaulttile={$defaultTile} 
	defaulttilecopy='wcf.global.leaflet.copy.{$defaultTile}' 
	zoom={$googleMapsZoom} 
	lat={$googleMapsLat} 
	lng={$googleMapsLng} 
	{if $tileconnectdirect}direct {if $defaultTile=='custom'}urltemplate={LEAFLET_CUSTOM_LAYER_URLTEMPLATE} {/if}{/if}
	{if $googleMapsBounds|isset && !$googleMapsBounds|empty}bounds='{$googleMapsBounds}' {/if}
	{if $accessUserLocation|isset && $accessUserLocation}access-user-location {/if}
	{if $leafletHidden}hidden {/if}
	style='z-index: 0'>
</woltlab-core-leaflet>

{if $leafletHidden}
	{if $defaultTile == 'openstreetmap'}
		{include file='messageUserConsent' host='tile.openstreetmap.org' url='https://tile.openstreetmap.org/' target=$leafletElementID sandbox=true}
	{elseif $defaultTile|str_starts_with:'topplus_open'}
		{include file='messageUserConsent' host='sgx.geodatenzentrum.de' url='http://www.bkg.bund.de/' target=$leafletElementID sandbox=true}
	{else}
		{include file='messageUserConsent' host=LEAFLET_CUSTOM_LAYER_HOST|encodeJS url=LEAFLET_CUSTOM_LAYER_URL|encodeJS target=$leafletElementID sandbox=true}
	{/if}
{/if}

{include file='leafletJavaScript'}
