{include file='leafletJavaScript'}

{if $field->getValue() !== null && !$field->getValue()|empty}
    {assign var='googleMapsLat' value=$field->getValue()['lat']}
    {assign var='googleMapsLng' value=$field->getValue()['lng']}
{/if}

{include file='leafletElement' leafletElementID=$field->getPrefixedId()}
<script data-relocate="true">
    require(["xXSchrandXx/Core/Form/Builder/Field/Controller/Leaflet"], function(L) {
        var field = new L('{$field->getPrefixedId()|encodeJS}');
        field.init();
        {if $accessUserLocation|isset && $accessUserLocation}
            field.#locate();
        {/if}
    });
</script>
