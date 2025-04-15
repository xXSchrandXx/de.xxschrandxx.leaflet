<?php

namespace wcf\system\cache\builder;

use GuzzleHttp\Exception\GuzzleException;
use GuzzleHttp\Psr7\Request;
use wcf\system\cache\CacheHandler;
use wcf\system\exception\SystemException;
use wcf\system\io\HttpFactory;

class LeafletTileCacheBuilder extends AbstractCacheBuilder
{
    /**
     * @inheritDoc
     */
    public function getData(array $parameters = [], $arrayIndex = '')
    {
        $url = $parameters['url'];
        if (!isset($url) && !empty($url)) {
            throw new \InvalidArgumentException('No tile layer url defined.');
        }
        unset($parameters['url']);
        $index = CacheHandler::getInstance()->getCacheIndex($parameters);

        if (!isset($this->cache[$index])) {
            // fetch cache or rebuild if missing
            $this->cache[$index] = CacheHandler::getInstance()->get($this, $parameters);
            if ($this->cache[$index] === null) {
                $this->cache[$index] = [$this->request($url)];

                // update cache
                CacheHandler::getInstance()->set($this, $parameters, $this->cache[$index]);
            }
        }

        if (!empty($arrayIndex)) {
            if (!\array_key_exists($arrayIndex, $this->cache[$index])) {
                throw new SystemException("array index '" . $arrayIndex . "' does not exist in cache resource");
            }

            return $this->cache[$index][$arrayIndex];
        }

        return $this->cache[$index];
    }

    /**
     * @inheritDoc
     */
    public function rebuild(array $parameters)
    {
        return [];
    }

    /**
     * @param string $url url for request
     * @throws \InvalidArgumentException
     * @throws GuzzleException
     * @return string
     */
    public static function request(string $url): string
    {
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
        return $response->getBody()->getContents();
    }
}
