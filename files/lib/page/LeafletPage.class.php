<?php

namespace wcf\page;

use wcf\system\WCF;

class LeafletPage extends AbstractPage
{
    /**
     * @inheritDoc
     */
    public function assignVariables()
    {
        parent::assignVariables();

        $lat = 53;
        $lng = 9;

        WCF::getTPL()->assign([
            'openStreetMapsElements' => [
                1 => [
                    'lat' => $lat,
                    'lng' => $lng,
                    'marker' => [
                        0 => [
                            'lat' => $lat,
                            'lng' => $lng,
                            'popup' => 'I am a marker',
                            'open' => true
                        ],
                        1 => [
                            'lat' => $lat + 0.1,
                            'lng' => $lng,
                            'popup' => 'I am another marker',
                            'open' => false
                        ]
                    ],
                    'style' => "width: 500px; height: 400px;"
                ]
            ],
            'openStreetMapsElementID' => 1
        ]);
    }
}
