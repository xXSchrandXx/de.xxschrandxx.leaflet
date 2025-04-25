<?php

namespace wcf\system\option;

use wcf\data\option\Option;
use wcf\event\leaflet\UrlTemplateCollecting;
use wcf\system\event\EventHandler;

class LeafletDefaultTileOptionType extends SelectOptionType
{
    /**
     * @inheritDoc
     */
    public function getSelectOptions(Option $option)
    {
        $options = parent::getSelectOptions($option);
        $event = new UrlTemplateCollecting();
        EventHandler::getInstance()->fire($event);
        $collection = [];
        foreach ($event->getTemplates() as $key => $urlTemplate) {
            $collection[$key] = "wcf.acp.option.leaflet_default_layer." . $key;
        }
        return array_merge($options, $collection);
    }
}
