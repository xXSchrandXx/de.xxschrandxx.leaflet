<?php

namespace wcf\system\endpoint\controller\xxschrandxx\leaflet;

use GuzzleHttp\Psr7\Response;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use wcf\system\cache\builder\LeafletTileCacheBuilder;
use wcf\system\endpoint\GetRequest;
use wcf\system\endpoint\IController;

#[GetRequest('/xxschrandxx/leaflet/tile/{z}/{x}/{y}[/{tile}[/{s}[/{r}]]]')]
final class GetTile implements IController
{
    #[\Override]
    public function __invoke(ServerRequestInterface $request, array $variables): ResponseInterface
    {
        $defaultTile = $variables['tile'] ?? LEAFLET_DEFAULT_LAYER;
        $url = null;
        switch ($defaultTile) {
            case 'openstreetmap':
                $url = "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png";
                break;
            case 'topplus_open':
                $url = "https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web/default/WEBMERCATOR/{z}/{y}/{x}.png";
                break;
            case 'topplus_open_grau':
                $url = "https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web_grau/default/WEBMERCATOR/{z}/{y}/{x}.png";
                break;
            case 'topplus_open_light':
                $url = "https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web_light/default/WEBMERCATOR/{z}/{y}/{x}.png";
                break;
            case 'topplus_open_light_grau':
                $url = "https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web_light_grau/default/WEBMERCATOR/{z}/{y}/{x}.png";
                break;
            case 'custom':
                $url = LEAFLET_CUSTOM_LAYER_URLTEMPLATE;
                break;
        }
        if ($url === null || empty($url)) {
            throw new \InvalidArgumentException('No tile layer url defined.');
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
            ])[0];
        } else {
            $png = LeafletTileCacheBuilder::request($url);
        }

        return new Response(
            200,
            [
                'Content-Type' => 'image/png',
                'Cache-Control' => 'public, max-age=31536000, immutable',
                'Expires' => gmdate('D, d M Y H:i:s', time() + 31536000) . ' GMT',
                'X-Cache' => LEAFLET_ENABLE_CACHE ? 'HIT' : 'MISS',
                'X-Cache-Url' => $url,
                'X-Cache-Size' => strlen($png),
            ],
            $png
        );
    }
}
