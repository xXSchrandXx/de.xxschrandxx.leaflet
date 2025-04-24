export function r(defaulttile: string, defaulttilecopy: string, direct: boolean, urltemplate: string = ""): void {
  // Alle <woltlab-core-google-maps> Elemente im DOM finden
  const googleMapsElements = document.getElementsByTagName("woltlab-core-google-maps");

  Array.from(googleMapsElements).forEach((element) => {
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

    // Add direct attribute if not set
    if (!leafletElement.hasAttribute("direct") && direct) {
      leafletElement.setAttribute("direct", "");
    }

    // Add custom URL template if not set
    if (!leafletElement.hasAttribute("urltemplate") && urltemplate) {
      leafletElement.setAttribute("urltemplate", urltemplate);
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
