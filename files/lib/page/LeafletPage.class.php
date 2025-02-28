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

        $lat1 = 48.400002;
        $lng1 = 9.983333;
        $lat2 = 53.143890;
        $lng2 = 8.213889;

        WCF::getTPL()->assign([
            'openStreetMapsElements' => [
                1 => [
                    'lat' => $lat1,
                    'lng' => $lng1,
                    'marker' => [
                        0 => [
                            'lat' => $lat1,
                            'lng' => $lng1,
                            'popup' => 'I am a marker',
                            'open' => true
                        ],
                        1 => [
                            'lat' => $lat1 + 0.1,
                            'lng' => $lng1,
                            'popup' => 'I am another marker',
                            'open' => false
                        ]
                    ],
                    'style' => "width: 100%; height: 500px;"
                ],
                2 => [
                    'lat' => $lat2,
                    'lng' => $lng2,
                    'marker' => [
                        0 => [
                            'lat' => $lat2,
                            'lng' => $lng2,
                            'popup' => 'I am a marker',
                            'open' => true
                        ],
                        1 => [
                            'lat' => $lat2 - 0.1,
                            'lng' => $lng2,
                            'popup' => 'I am another marker',
                            'open' => false
                        ]
                    ],
                    'style' => "width: 100%; height: 500px;"
                ]
            ]
        ]);
    }
}
