<?php

namespace wcf\system\endpoint\controller\xxschrandxx\leaflet;

use GuzzleHttp\Exception\GuzzleException;
use GuzzleHttp\Psr7\Request;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use wcf\system\endpoint\GetRequest;
use wcf\system\endpoint\IController;
use wcf\system\io\HttpFactory;

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
                $url = LEAFLET_CUSTOM_LAYER_LINK;
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
        $client = HttpFactory::makeClient();
        $request = new Request('GET', $url);
        $response = null;
        try {
            $response = $client->send($request);
        } catch (GuzzleException $e) {
            if (ENABLE_DEBUG_MODE) {
                throw new \InvalidArgumentException('GuzzleException: ' . $e->getMessage());
            } else {
                throw new \InvalidArgumentException('GuzzleException');
            }
        }
        if ($response === null) {
            throw new \InvalidArgumentException('Tile layer url did not response.');
        }
        return $response;
    }
}
