import L from "leaflet";
import WoltlabCoreLeafletElement from "xXSchrandXx/Core/Component/Leaflet/woltlab-core-leaflet";

class Leaflet {
    protected readonly _formFieldContainer: HTMLElement;
    protected readonly _formField: HTMLInputElement;
    protected readonly _map: WoltlabCoreLeafletElement;
    protected latlng: L.LatLng | undefined;
    protected marker: L.Marker;
    #markerLoaded: Promise<void>;
    #markerLoadedResolve?: () => void;

    constructor(fieldId: string) {
        this._formFieldContainer = document.getElementById(fieldId + "Container")!;
        if (this._formFieldContainer === null) {
            throw new TypeError("container \"" + fieldId + "Container\" not found.");
        }
        this._formField = document.getElementById(fieldId) as HTMLInputElement;
        if (this._formField === null) {
            throw new TypeError("field \"" + fieldId + "\" not found.");
        }
        this._map = document.getElementById(fieldId + "_map") as WoltlabCoreLeafletElement;
        if (this._map === null) {
            throw new TypeError("map for \"" + fieldId + "\" not found.");
        }

        this.#markerLoaded = new Promise<void>((resolve) => {
            this.#markerLoadedResolve = resolve;
        });
    }

    async setLatLng(latlng: L.LatLng): Promise<void> {
        await this.#markerLoaded;

        this.latlng = latlng;
        this.marker.setLatLng(this.latlng);
        this._map.setAttribute("lat", latlng.lat.toString());
        this._map.setAttribute("lng", latlng.lng.toString());
        this._formField.value = JSON.stringify({ lat: latlng.lat, lng: latlng.lng });;
    }

    async #locate(): Promise<void> {
        await this.#markerLoaded;

        var map: L.Map = (await this._map.getMap());
        map.locate({setView: true});
        if (this.latlng === undefined) {
            map.on("locationfound", (e: L.LocationEvent) => {
                this.setLatLng(e.latlng);
            });
        }
    }

    async init(): Promise<void> {
        if (this.latlng === undefined) {
            this.latlng = new L.LatLng(this._map.lat, this._map.lng);
        } else {
            this.setLatLng(this.latlng);
        }
        if (this.latlng === undefined) {
            throw new TypeError("latlng is undefined");
        }
        this.marker = L.marker(this.latlng, {
            draggable: true
        });
        this.marker.addTo(await this._map.getMap());
        this.marker.on("dragend", (e: L.DragEndEvent) => {
            this.setLatLng(e.target.getLatLng());
        });
        
        if (this.#markerLoadedResolve) {
            this.#markerLoadedResolve();
            this.#markerLoadedResolve = undefined;
        }
    }
}

export = Leaflet;
