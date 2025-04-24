/**
 * The `<woltlab-core-google-maps>` element creates a map via LeafletJS.
 *
 * @author Marcel Werk - Modified by xXSchrandXx
 * @copyright 2001-2022 WoltLab GmbH
 * @license GNU Lesser General Public License <http://opensource.org/licenses/lgpl-license.php>
 */

import * as L from "leaflet";
import * as M from "./Marker";
import { getPhrase } from "WoltLabSuite/Core/Language";

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
        }
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
        lng: this.lng
      }
    });

    void this.#setTileLayer();

    void this.#setBounds();

    void this.#locate();

    if (this.#mapLoadedResolve) {
      this.#mapLoadedResolve();
      this.#mapLoadedResolve = undefined;
    }
  }

  async #setTileLayer(tile?: string, options: L.TileLayerOptions = {}): Promise<void> {
    await this.#mapLoaded;

    let defaultTile;
    if (tile) {
      defaultTile = tile;
    } else {
      defaultTile = this.defaultTile;
    }
    const copy = this.defaultTileCopy;
    if (copy) {
      options.attribution = getPhrase(copy);
    }
    if (defaultTile) {
      if (this.direct) {
        let url = "";
        switch (defaultTile) {
          case "openstreetmap":
            url = "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png";
            break;
          case "topplus_open":
            url = "https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web/default/WEBMERCATOR/{z}/{y}/{x}.png";
            break;
          case "topplus_open_grau":
            url = "https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web_grau/default/WEBMERCATOR/{z}/{y}/{x}.png";
            break;
          case "topplus_open_light":
            url = "https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web_light/default/WEBMERCATOR/{z}/{y}/{x}.png";
            break;
          case "topplus_open_light_grau":
            url = "https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web_light_grau/default/WEBMERCATOR/{z}/{y}/{x}.png";
            break;
          case "custom":
            url = this.customurl;
            break;
        }
        L.tileLayer(url, options).addTo(this.#map!);
      } else {
        L.tileLayer(`${window.WSC_RPC_API_URL}xxschrandxx/leaflet/tile/{z}/{x}/{y}/${defaultTile}/{s}`, options).addTo(this.#map!);
      }
    }
  }

  async #setBounds(bounds?: L.LatLngBounds | null): Promise<void> {
    await this.#mapLoaded;

    let b;
    if (bounds) {
      b = bounds;
    } else {
      b = this.bounds;
    }
    if (b) {
      this.#map!.fitBounds(b);
    }
  }

  async #locate(locate?: boolean): Promise<void> {
    await this.#mapLoaded;

    let l;
    if (locate) {
      l = locate;
    } else {
      l = this.hasAttribute("access-user-location");
    }
    if (l) {
      this.#map!.locate({ setView: true });
    }
  }

  async #addMarker(lat: number, lng: number, title?: string, popup?: L.Content, focus?: boolean): Promise<L.Marker> {
    await this.#mapLoaded;
    return M.addMarker(this, lat, lng, title, popup, focus);
  }

  async #addDraggableMarker(lat: number, lng: number, title?: string, popup?: L.Content, focus?: boolean): Promise<L.Marker> {
    await this.#mapLoaded;
    return M.addDraggableMarker(this, lat, lng, title, popup, focus);
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

  get bounds(): L.LatLngBounds | null {
    if (this.getAttribute("bounds")) {
      return JSON.parse(this.getAttribute("bounds")!) as L.LatLngBounds;
    }

    return null;
  }

  get direct(): boolean {
    return this.hasAttribute("direct");
  }

  get customurl(): string {
    return this.getAttribute("urltemplate") || "";
  }
}

window.customElements.define("woltlab-core-leaflet", WoltlabCoreLeafletElement);

export default WoltlabCoreLeafletElement;
