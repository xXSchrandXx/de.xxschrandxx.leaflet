{if !$__leafletInit|isset}
	{assign var=__leafletInit value=1}

	<script data-relocate="true">
		{jsphrase name='wcf.global.leaflet.copy.openstreetmap'}
		{jsphrase name='wcf.global.leaflet.copy.topplus_open'}
		{jsphrase name='wcf.global.leaflet.copy.topplus_open_grau'}
		{jsphrase name='wcf.global.leaflet.copy.topplus_open_light'}
		{jsphrase name='wcf.global.leaflet.copy.topplus_open_light_grau'}
		{jsphrase name='wcf.global.leaflet.copy.custom'}

		require.config({
			packages: [{
				name: 'leaflet',
				main: 'leaflet'
			}],
			paths: {
				'leaflet': '{$__wcf->getPath('wcf')}js/3rdParty/leaflet'
			}
		});

		require(["xXSchrandXx/Core/Component/Leaflet/leaflet-map"]);
	</script>
{/if}
