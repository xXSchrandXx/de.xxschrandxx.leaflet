/**
 * Provides functions to add markers to a map.
 *
 * @author Marcel Werk - Modified by xXSchrandXx
 * @copyright  2001-2022 WoltLab GmbH
 * @license  GNU Lesser General Public License <http://opensource.org/licenses/lgpl-license.php>
 */

import * as L from "leaflet";
import LeafletMapElement from "xXSchrandXx/Core/Component/Leaflet/leaflet-map";

export async function addMarkerById(
  id: string,
  latitude: number,
  longitude: number,
  title?: string,
  popup?: L.Content,
  focus?: boolean
): Promise<L.Marker> {
  const element = document.getElementById(id) as LeafletMapElement;
  return addMarker(element, latitude, longitude, title, popup, focus);
}

export async function addMarker(
  element: LeafletMapElement,
  latitude: number,
  longitude: number,
  title?: string,
  popup?: L.Content,
  focus?: boolean
): Promise<L.Marker> {
  const marker = new L.Marker(new L.LatLng(latitude, longitude), {
    title: title,
    autoPan: focus
  });
  if (popup !== undefined) {
    marker.bindPopup(popup);
  }
  marker.addTo(await element.getMap());
  return marker;
}

export async function addDraggableMarkerById(
  id: string,
  latitude?: number,
  longitude?: number,
  title?: string,
  popup?: L.Content,
  focus?: boolean
): Promise<L.Marker> {
  const element = document.getElementById(id) as LeafletMapElement;
  return addDraggableMarker(element, latitude, longitude, title, popup, focus);
}

export async function addDraggableMarker(
  element: LeafletMapElement,
  latitude?: number,
  longitude?: number,
  title?: string,
  popup?: L.Content,
  focus?: boolean
): Promise<L.Marker> {
  if (latitude === undefined) {
    latitude = element.lat;
  }
  if (longitude === undefined) {
    longitude = element.lng;
  }
  if (title === undefined) {
    title = "";
  }
  const marker = new L.Marker(new L.LatLng(latitude, longitude), {
    draggable: true,
    title: title,
    autoPan: focus
  });
  if (popup !== undefined) {
    marker.bindPopup(popup);
  }
  marker.addTo(await element.getMap());
  return marker;
}
