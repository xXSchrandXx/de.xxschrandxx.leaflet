{if !$__leafletInit|isset}
	{assign var=__leafletInit value=1}

    <link rel="stylesheet" href="{@$__wcf->getPath()}js/3rdParty/leaflet/leaflet.css" />
    <script data-relocate="true">
    require.config({
        packages: [{
            name: 'leaflet',
            main: 'leaflet'
        }],
        paths: {
            'leaflet': '{$__wcf->getPath('wcf')}js/3rdParty/leaflet'
        }
    });
    
    require(["xXSchrandXx/Core/Component/Leaflet/woltlab-core-leaflet"]);
    </script>
{/if}
