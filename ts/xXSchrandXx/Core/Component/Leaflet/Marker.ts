
import * as L from "leaflet";
import WoltlabCoreLeafletElement from "./woltlab-core-leaflet";
import "./woltlab-core-leaflet";

export async function addMarker(
  element: WoltlabCoreLeafletElement,
  latitude: number,
  longitude: number,
  title?: string,
  popup?: L.Content,
  focus?: boolean,
): Promise<L.Marker> {
  const marker = new L.Marker(new L.LatLng(latitude, longitude), {
    title: title,
    autoPan: focus,
  });
  if (popup !== undefined) {
    marker.bindPopup(popup);
  }
  marker.addTo(await element.getMap());
  return marker;
}

export async function addDraggableMarker(
  element: WoltlabCoreLeafletElement,
  latitude?: number,
  longitude?: number,
  title?: string,
  popup?: L.Content,
  focus?: boolean,
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
    autoPan: focus,
  });
  if (popup !== undefined) {
    marker.bindPopup(popup);
  }
  marker.addTo(await element.getMap());
  return marker;
}
