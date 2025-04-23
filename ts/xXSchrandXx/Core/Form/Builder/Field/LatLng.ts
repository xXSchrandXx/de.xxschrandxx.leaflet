/**
 * Data handler for a form builder field in an Ajax form that stores its value in an lat and lng
 * attribute.
 *
 * @license GNU Lesser General Public License <http://opensource.org/licenses/lgpl-license.php>
 */

import Field from "WoltLabSuite/Core/Form/Builder/Field/Field";
import { FormBuilderData } from "WoltLabSuite/Core/Form/Builder/Data";
import WoltlabCoreLeafletElement from "xXSchrandXx/Core/Component/Leaflet/woltlab-core-leaflet";

class LatLng extends Field {
  protected _getData(): FormBuilderData {
    var field = this._field as WoltlabCoreLeafletElement;
    console.log(field);
    console.log(field.lat, field.lng);
    return {
      [this._fieldId]: {'lat': field.lat, 'lng': field.lng},
    };
  }
}

export = LatLng;
