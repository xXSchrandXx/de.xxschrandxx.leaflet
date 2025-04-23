import L from "leaflet";
import WoltlabCoreLeafletElement from "xXSchrandXx/Core/Component/Leaflet/woltlab-core-leaflet";

class Leaflet {
    protected readonly _formFieldContainer: HTMLElement;
    protected readonly _element: WoltlabCoreLeafletElement;
    protected latlng: L.LatLng | undefined;
    protected marker: L.Marker;
    #markerLoaded: Promise<void>;
    #markerLoadedResolve?: () => void;

    constructor(fieldId: string) {
        this._formFieldContainer = document.getElementById(fieldId + "Container")!;
        if (this._formFieldContainer === null) {
            throw new TypeError("container \"" + fieldId + "Container\" not found.");
        }
        this._element = document.getElementById(fieldId) as WoltlabCoreLeafletElement;
        if (this._element === null) {
            throw new TypeError("field \"" + fieldId + "\" not found.");
        }

        this.#markerLoaded = new Promise<void>((resolve) => {
            this.#markerLoadedResolve = resolve;
        });
    }

    async #setLatLng(latlng: L.LatLng): Promise<void> {
        await this.#markerLoaded;

        this.latlng = latlng;
        this.marker.setLatLng(this.latlng);
    }

    async #locate(): Promise<void> {
        await this.#markerLoaded;

        var map: L.Map = (await this._element.getMap());
        map.locate({setView: true});
        if (this.latlng === undefined) {
            map.on("locationfound", (e: L.LocationEvent) => {
                this.#setLatLng(e.latlng);
            });
        }
    }

    async init(): Promise<void> {
        if (this.latlng === undefined) {
            this.latlng = new L.LatLng(this._element.lat, this._element.lng);
        }
        if (this.latlng === undefined) {
            throw new TypeError("latlng is undefined");
        }
        this.marker = L.marker(this.latlng, {
            draggable: true
        });
        this.marker.addTo(await this._element.getMap());
        this.marker.on("dragend", (e: L.DragEndEvent) => {
            this.#setLatLng(e.target.getLatLng());
            this._element.setAttribute("lat", e.target.getLatLng().lat);
            this._element.setAttribute("lng", e.target.getLatLng().lng);
        });
        
        if (this.#markerLoadedResolve) {
            this.#markerLoadedResolve();
            this.#markerLoadedResolve = undefined;
        }
    }
}

export = Leaflet;
