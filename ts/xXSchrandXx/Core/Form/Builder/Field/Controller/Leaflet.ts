import L from "leaflet";
import WoltlabCoreLeafletElement from "xXSchrandXx/Core/Component/Leaflet/woltlab-core-leaflet";
import { confirmationFactory } from "WoltLabSuite/Core/Component/Confirmation";
import Language from "WoltLabSuite/Core/Language";

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
      throw new TypeError(`container "${fieldId}Container" not found.`);
    }
    this._formField = document.getElementById(fieldId) as HTMLInputElement;
    if (this._formField === null) {
      throw new TypeError(`field "${fieldId}" not found.`);
    }
    this._map = document.getElementById(fieldId + "_map") as WoltlabCoreLeafletElement;
    if (this._map === null) {
      throw new TypeError(`map for "${fieldId}" not found.`);
    }
    this.#markerLoaded = new Promise<void>((resolve) => {
      this.#markerLoadedResolve = resolve;
    });
    this.latlng = this._formField.value !== "" ? JSON.parse(this._formField.value) : undefined;
  }

  async setLatLng(latlng: L.LatLng, move: boolean = true): Promise<void> {
    if (move) {
      await this.#markerLoaded;
      this.marker.setLatLng(latlng);
    }

    this.latlng = latlng;
    this._map.setAttribute("lat", latlng.lat.toString());
    this._map.setAttribute("lng", latlng.lng.toString());
    this._formField.value = JSON.stringify({ lat: latlng.lat, lng: latlng.lng });
  }

  async locate(): Promise<void> {
    (await this._map.getMap()).locate({ setView: true });
    const result = confirmationFactory()
      .custom(Language.getPhrase("wcf.global.leaflet.formfield.locate"))
      .withoutMessage();
    (await this._map.getMap()).once("locationfound", async (e: L.LocationEvent) => {
      if (await result) {
        this.marker = L.marker(e.latlng, {
          draggable: true
        });
        if (this.#markerLoadedResolve) {
          this.#markerLoadedResolve();
          this.#markerLoadedResolve = undefined;
        }
        await this.setLatLng(e.latlng, false);
        (await this._map.getMap()).stopLocate();
      }
    });
  }

  async init(locate: boolean = false): Promise<void> {
    if (this.latlng === undefined) {
      if (locate) {
        this.locate();
      }
      if (this.marker === undefined) {
        (await this._map.getMap()).once("click", async (e: L.LeafletMouseEvent) => {
          this.marker = L.marker(e.latlng, {
            draggable: true
          });
          if (this.#markerLoadedResolve) {
            this.#markerLoadedResolve();
            this.#markerLoadedResolve = undefined;
          }
          await this.setLatLng(e.latlng, false);
        });
      }
    } else {
      this.marker = L.marker(this.latlng, {
        draggable: true
      });
      if (this.#markerLoadedResolve) {
        this.#markerLoadedResolve();
        this.#markerLoadedResolve = undefined;
      }
      (await this._map.getMap()).panTo(this.latlng);
      await this.setLatLng(this.latlng, false);
    }

    await this.#markerLoaded;

    this.marker.addTo(await this._map.getMap());
    this.marker.on("dragend", async (e: L.DragEndEvent) => {
      await this.setLatLng(e.target.getLatLng(), false);
    });
    (await this._map.getMap()).on("click", async (e: L.LeafletMouseEvent) => {
      await this.setLatLng(e.latlng);
    });
  }
}

export = Leaflet;
