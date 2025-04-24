{include file='leafletJavaScript'}

{if $field->getValue() !== null && $field->getValue()|is_array && !$field->getValue()|empty}
	{assign var='googleMapsLat' value=$field->getArrayValue()['lat']}
	{assign var='googleMapsLng' value=$field->getArrayValue()['lng']}
{/if}

{include file='leafletElement' leafletElementID=$field->getPrefixedId()|concat:"_map"}
<input type="hidden" id="{$field->getPrefixedId()}" name="{$field->getPrefixedId()}" value{if $field->getValue() !== null && !$field->getValue()|empty}="{$field->getValue()}"{/if} />
<script data-relocate="true">
	{jsphrase name='wcf.global.leaflet.formfield.locate'}
	require(["xXSchrandXx/Core/Form/Builder/Field/Controller/Leaflet"], function(Leaflet) {
		var field = new Leaflet('{$field->getPrefixedId()|encodeJS}');
		field.init({if $accessUserLocation|isset && $accessUserLocation}true{/if});
	});
</script>
