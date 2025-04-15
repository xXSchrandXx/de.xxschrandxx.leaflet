export function r(defaulttile: string, defaulttilecopy: string) {
    console.log("Replacing <woltlab-core-google-maps> with <woltlab-core-leaflet>...");
    // Alle <woltlab-core-google-maps> Elemente im DOM finden
    const googleMapsElements = document.getElementsByTagName("woltlab-core-google-maps");
    console.log("Found <woltlab-core-google-maps> elements: ", googleMapsElements);

    Array.from(googleMapsElements).forEach((element) => {
        console.log("Replacing element: ", element);
        // Neues <woltlab-core-leaflet> Element erstellen
        const leafletElement = document.createElement("woltlab-core-leaflet");

        // Attribute vom alten Element auf das neue Element übertragen
        for (const attr of element.attributes) {
            leafletElement.setAttribute(attr.name, attr.value);
        }

        // Add default tile layer if not set
        if (!leafletElement.hasAttribute("defaulttile")) {
            leafletElement.setAttribute("defaulttile", defaulttile);
        }

        // Add default tile copy if not set
        if (!leafletElement.hasAttribute("defaulttilecopy")) {
            leafletElement.setAttribute("defaulttilecopy", defaulttilecopy);
        }

        // Inhalte (falls vorhanden) übertragen
        leafletElement.innerHTML = element.innerHTML;

        // Altes Element durch das neue ersetzen
        element.replaceWith(leafletElement);
    });
}

/* TODO
export function replaceGoogleMarker() {
}
*/
