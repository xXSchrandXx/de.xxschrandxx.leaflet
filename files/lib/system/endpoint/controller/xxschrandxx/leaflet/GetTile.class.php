<?php

namespace wcf\system\endpoint\controller\xxschrandxx\leaflet;

use GuzzleHttp\Psr7\Response;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use wcf\event\leaflet\UrlTemplateCollecting;
use wcf\system\cache\builder\LeafletTileCacheBuilder;
use wcf\system\endpoint\GetRequest;
use wcf\system\endpoint\IController;
use wcf\system\event\EventHandler;
use wcf\system\exception\PermissionDeniedException;
use wcf\system\exception\UserInputException;

/**
 * Parameters
 * z=z-coordinate : number
 * x=x-coordinate : number
 * y=y-coordinate : number
 * tile = openstreetmap, topplus_open, topplus_open_grau, topplus_open_light, topplus_open_light_grau, custom or registered through UrlTemplateCollecting
 * s=sequence value for parralel browsing : number/string
 * r=weather retina files should be requested : @2x or empty 
 */
#[GetRequest('/xxschrandxx/leaflet/tile/{z:\d+}/{x:\d+}/{y:\d+}[/{tile}[/{s:\d+|\w+}[/{r:@2x}]]]')]
final class GetTile implements IController
{
    #[\Override]
    public function __invoke(ServerRequestInterface $request, array $variables): ResponseInterface
    {
        if (LEAFLET_DEFAULT_CONNECTION) {
            throw new PermissionDeniedException();
        }
        if ($variables['z'] < 0) {
            throw new UserInputException('z', 'lessThan', ['lessThan' => 0]);
        }
        if ($variables['x'] < 0) {
            throw new UserInputException('x', 'lessThan', ['lessThan' => 0]);
        }
        if ($variables['y'] < 0) {
            throw new UserInputException('y', 'lessThan', ['lessThan' => 0]);
        }
        $defaultTile = $variables['tile'] ?? LEAFLET_DEFAULT_LAYER;
        $url = null;
        switch ($defaultTile) {
            case 'openstreetmap':
                if ($variables['z'] > 20) {
                    throw new UserInputException('z', 'greaterThan', ['greaterThan' => 20]);
                }
                if ($variables['x'] > 2**20) {
                    throw new UserInputException('x', 'greaterThan', ['greaterThan' => 2**20]);
                }
                if ($variables['y'] > 2**20) {
                    throw new UserInputException('y', 'greaterThan', ['greaterThan' => 2**20]);
                }
                $url = "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png";
                break;
            case 'topplus_open':
                if ($variables['z'] > 19) {
                    throw new UserInputException('z', 'greaterThan', ['greaterThan' => 19]);
                }
                if ($variables['x'] > 2**19) {
                    throw new UserInputException('x', 'greaterThan', ['greaterThan' => 2**19]);
                }
                if ($variables['y'] > 2**19) {
                    throw new UserInputException('y', 'greaterThan', ['greaterThan' => 2**19]);
                }
                $url = "https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web/default/WEBMERCATOR/{z}/{y}/{x}.png";
                break;
            case 'topplus_open_grau':
                if ($variables['z'] > 19) {
                    throw new UserInputException('z', 'greaterThan', ['greaterThan' => 19]);
                }
                if ($variables['x'] > 2**19) {
                    throw new UserInputException('x', 'greaterThan', ['greaterThan' => 2**19]);
                }
                if ($variables['y'] > 2**19) {
                    throw new UserInputException('y', 'greaterThan', ['greaterThan' => 2**19]);
                }
                $url = "https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web_grau/default/WEBMERCATOR/{z}/{y}/{x}.png";
                break;
            case 'topplus_open_light':
                if ($variables['z'] > 19) {
                    throw new UserInputException('z', 'greaterThan', ['greaterThan' => 19]);
                }
                if ($variables['x'] > 2**19) {
                    throw new UserInputException('x', 'greaterThan', ['greaterThan' => 2**19]);
                }
                if ($variables['y'] > 2**19) {
                    throw new UserInputException('y', 'greaterThan', ['greaterThan' => 2**19]);
                }
                $url = "https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web_light/default/WEBMERCATOR/{z}/{y}/{x}.png";
                break;
            case 'topplus_open_light_grau':
                if ($variables['z'] > 19) {
                    throw new UserInputException('z', 'greaterThan', ['greaterThan' => 19]);
                }
                if ($variables['x'] > 2**19) {
                    throw new UserInputException('x', 'greaterThan', ['greaterThan' => 2**19]);
                }
                if ($variables['y'] > 2**19) {
                    throw new UserInputException('y', 'greaterThan', ['greaterThan' => 2**19]);
                }
                $url = "https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web_light_grau/default/WEBMERCATOR/{z}/{y}/{x}.png";
                break;
            case 'custom':
                // unknown max z
                $url = LEAFLET_CUSTOM_LAYER_URLTEMPLATE;
                break;
            default:
                $event = new UrlTemplateCollecting();
                EventHandler::getInstance()->fire($event);
                if (array_key_exists($defaultTile, $event->getTemplates())) {
                    if ($variables['z'] > $event->getMaxZooms()[$defaultTile]) {
                        throw new UserInputException('z', 'greaterThan', ['greaterThan' => $event->getMaxZooms()[$defaultTile]]);
                    }
                    if ($variables['x'] > 2**$event->getMaxZooms()[$defaultTile]) {
                        throw new UserInputException('x', 'greaterThan', ['greaterThan' => 2**$event->getMaxZooms()[$defaultTile]]);
                    }
                    if ($variables['y'] > 2**$event->getMaxZooms()[$defaultTile]) {
                        throw new UserInputException('x', 'greaterThan', ['greaterThan' => 2**$event->getMaxZooms()[$defaultTile]]);
                    }
                    $url = $event->getTemplates()[$defaultTile];
                }
                break;
        }
        if ($url === null || empty($url)) {
            throw new UserInputException('url');
        }
        $url = str_replace('{z}', $variables['z'], $url);
        $url = str_replace('{x}', $variables['x'], $url);
        $url = str_replace('{y}', $variables['y'], $url);
        if (array_key_exists('s', $variables)) {
            $url = str_replace('{s}', $variables['s'], $url);
        }
        if (array_key_exists('r', $variables)) {
            $url = str_replace('{r}', $variables['r'], $url);
        }

        if (LEAFLET_ENABLE_CACHE) {
            $png = LeafletTileCacheBuilder::getInstance()->getData([
                'url' => $url,
                'tile' => $defaultTile,
                'z' => $variables['z'],
                'x' => $variables['x'],
                'y' => $variables['y'],
                'r' => $variables['r'] ?? ''
            ])[0];
        } else {
            $png = LeafletTileCacheBuilder::request($url);
        }

        return new Response(
            200,
            [
                'Content-Type' => 'image/png',
                'Cache-Control' => 'public, max-age=31536000, immutable',
                'Expires' => gmdate('D, d M Y H:i:s', time() + 31536000) . ' GMT'
            ],
            $png
        );
    }
}
