/**
 * The `<woltlab-core-google-maps>` element creates a map via LeafletJS.
 */

import * as L from "leaflet";
import {getPhrase} from "WoltLabSuite/Core/Language";

type Bounds = {
    southWest: {
        latitude: number;
        longitude: number;
    };
    northEast: {
        latitude: number;
        longitude: number;
    };
};

export class WoltlabCoreLeafletElement extends HTMLElement {
    #map?: L.Map;
    #mapLoaded: Promise<void>;
    #mapLoadedResolve?: () => void;
    #rendered = false;

    constructor() {
        super();

        this.#mapLoaded = new Promise<void>((resolve) => {
            this.#mapLoadedResolve = resolve;
        });
    }

    connectedCallback() {
        if (!this.hidden) {
            this.#render();
        }
    }

    attributeChangedCallback(name: string, oldValue: string | null, newValue: string | null): void {
        if (name === "hidden" && newValue === null) {
            this.#render();
        }
    }

    static get observedAttributes(): string[] {
        return ["hidden"];
    }

    #render(): void {
        if (this.#rendered) {
            return;
        }
        this.#validate();

        this.#rendered = true;

        if (this.hasAttribute("access-user-location")) {
            navigator.geolocation.getCurrentPosition(
                (response) => {
                    this.setAttribute("lat", response.coords.latitude.toString());
                    this.setAttribute("lng", response.coords.longitude.toString());

                    this.#initMap();
                },
                () => {
                    this.#initMap();
                },
            );
        } else {
            this.#initMap();
        }
    }

    #initMap(): void {
        this.#map = new L.Map(this, {
            zoom: this.zoom,
            center: {
                lat: this.lat,
                lng: this.lng,
            },
        });

        void this.#setTileLayer();

        void this.#setBounds();

        void this.#locate();

        if (this.#mapLoadedResolve) {
            this.#mapLoadedResolve();
            this.#mapLoadedResolve = undefined;
        }
    }

    async #setTileLayer(): Promise<void> {
        await this.#mapLoaded;

        const defaultTile = this.defaultTile;
        const copy = this.defaultTileCopy;
        var options = {};
        if (copy) {
            options = {
                attribution: getPhrase(copy),
            };
        }
        if (defaultTile) {
            L.tileLayer(defaultTile, options).addTo(this.#map!);
        }
    }

    async #setBounds(): Promise<void> {
        await this.#mapLoaded;

        const bounds = this.bounds;
        if (bounds) {
            this.#map!.fitBounds(
                new L.LatLngBounds(
                    new L.LatLng(bounds.southWest.latitude, bounds.southWest.longitude),
                    new L.LatLng(bounds.northEast.latitude, bounds.northEast.longitude),
                ),
            );
        }
    }

    async #locate(): Promise<void> {
        await this.#mapLoaded;

        const locate = this.hasAttribute("access-user-location");
        if (locate) {
            this.#map!.locate({setView: true});
        }
    }

    #validate(): void {
        if (!this.defaultTile) {
            throw new TypeError("Must provide a default tile.");
        }
    }

    async getMap(): Promise<L.Map> {
        await this.#mapLoaded;

        return this.#map!;
    }

    get defaultTile(): string {
        return this.getAttribute("defaulttile") || "";
    }

    get defaultTileCopy(): string {
        return this.getAttribute("defaulttilecopy") || "";
    }

    get lat(): number {
        return this.getAttribute("lat") ? parseFloat(this.getAttribute("lat")!) : 0;
    }

    get lng(): number {
        return this.getAttribute("lng") ? parseFloat(this.getAttribute("lng")!) : 0;
    }

    get zoom(): number {
        return this.getAttribute("zoom") ? parseInt(this.getAttribute("zoom")!) : 13;
    }

    get bounds(): Bounds | null {
        if (this.getAttribute("bounds")) {
            return JSON.parse(this.getAttribute("bounds")!) as Bounds;
        }

        return null;
    }
}

//window.customElements.define("woltlab-core-google-maps", WoltlabCoreLeafletElement);
window.customElements.define("woltlab-core-leaflet", WoltlabCoreLeafletElement);

export default WoltlabCoreLeafletElement;