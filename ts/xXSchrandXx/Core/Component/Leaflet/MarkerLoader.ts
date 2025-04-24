/**
 * Handles a large map with many markers where (new) markers are loaded via AJAX.
 *
 * @author Marcel Werk - Modified by xXSchrandXx
 * @copyright  2001-2022 WoltLab GmbH
 * @license  GNU Lesser General Public License <http://opensource.org/licenses/lgpl-license.php>
 */

import * as L from "leaflet";
import { dboAction } from "WoltLabSuite/Core/Ajax";
import WoltlabCoreLeafletElement from "./woltlab-core-leaflet";
import { dialogFactory } from "WoltLabSuite/Core/Component/Dialog";
import DomUtil from "WoltLabSuite/Core/Dom/Util";
import WoltlabCoreDialogElement from "WoltLabSuite/Core/Element/woltlab-core-dialog";
import * as M from "./Marker";
import "./woltlab-core-leaflet";

type AdditionalParameters = Record<string, unknown>;

type MarkerData = {
  dialog?: string;
  infoWindow: string;
  items: number;
  latitude: number;
  location: string;
  longitude: number;
  objectIDs?: number[];
  objectID?: number;
  title: string;
};

type ResponseGetMapMarkers = {
  markers: MarkerData[];
};

class MarkerLoader {
  readonly #leaflet: WoltlabCoreLeafletElement;
  #map: L.Map;
  readonly #actionClassName: string;
  readonly #additionalParameters: AdditionalParameters;
  #previousNorthEast: L.LatLng;
  #previousSouthWest: L.LatLng;
  #objectIDs: number[] = [];
  #marker: L.Marker[] = [];

  constructor(leaflet: WoltlabCoreLeafletElement, actionClassName: string, additionalParameters: AdditionalParameters) {
    this.#leaflet = leaflet;
    this.#actionClassName = actionClassName;
    this.#additionalParameters = additionalParameters;

    void this.#initLoadMarkers();
  }

  async #initLoadMarkers(): Promise<void> {
    this.#map = await this.#leaflet.getMap();
    if (this.#map.getBounds()) {
      // The map has already been loaded
      await this.#loadMarkers();
    }

    this.#map.addEventListener("moveend", () => {
      void this.#loadMarkers();
    });
    this.#map.addEventListener("zoomend", () => {
      void this.#loadMarkers();
    });
  }

  async #loadMarkers(): Promise<void> {
    const northEast = this.#map.getBounds()!.getNorthEast();
    const southWest = this.#map.getBounds()!.getSouthWest();

    if (!this.#checkPreviousLocation(northEast, southWest)) {
      return;
    }

    const response = (await dboAction("getMapMarkers", this.#actionClassName)
      .payload({
        ...this.#additionalParameters,
        excludedObjectIDs: JSON.stringify(this.#objectIDs),
        eastLongitude: northEast.lng,
        northLatitude: northEast.lat,
        southLatitude: southWest.lat,
        westLongitude: southWest.lng
      })
      .dispatch()) as ResponseGetMapMarkers;

    response.markers.forEach((data) => {
      this.#addMarker(data);
    });
  }

  async #addMarker(data: MarkerData) {
    if (data.objectID && this.#objectIDs.includes(data.objectID)) {
      return;
    }

    if (data.objectIDs) {
      data.objectIDs.forEach((objectID) => {
        if (this.#objectIDs.includes(objectID)) {
          return;
        }
      });
    }

    const marker = await M.addMarker(this.#leaflet, data.latitude, data.longitude, data.title);

    if (data.infoWindow) {
      const content = document.createElement("div");
      content.classList.add("googleMapsInfoWindow");
      DomUtil.setInnerHtml(content, data.infoWindow);

      marker.bindPopup(content);

      if (data.dialog) {
        let dialog: WoltlabCoreDialogElement;
        const button = content.querySelector<HTMLElement>(".jsButtonShowDialog");
        button?.addEventListener("click", () => {
          if (!dialog) {
            dialog = dialogFactory().fromHtml(data.dialog!).withoutControls();
          }
          dialog.show(button.dataset.title || button.textContent!);
        });
      }
    }

    this.#marker.push(marker);

    if (data.objectID) {
      this.#objectIDs.push(data.objectID);
    }

    if (data.objectIDs) {
      this.#objectIDs.push(...data.objectIDs);
    }
  }

  /**
   * Checks if the user has zoomed in, then all markers are already displayed.
   */
  #checkPreviousLocation(northEast: L.LatLng, southWest: L.LatLng): boolean {
    if (
      this.#previousNorthEast &&
      this.#previousNorthEast.lat >= northEast.lat &&
      this.#previousNorthEast.lng >= northEast.lng &&
      this.#previousSouthWest.lat <= southWest.lat &&
      this.#previousSouthWest.lng <= southWest.lng
    ) {
      return false;
    }

    this.#previousNorthEast = northEast;
    this.#previousSouthWest = southWest;

    return true;
  }
}

export async function setup(
  leaflet: WoltlabCoreLeafletElement,
  actionClassName: string,
  additionalParameters: AdditionalParameters
): Promise<void> {
  new MarkerLoader(leaflet, actionClassName, additionalParameters);
}
