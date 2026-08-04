<?php

namespace wcf\event\leaflet;

use wcf\event\IPsr14Event;

final class UrlTemplateCollecting implements IPsr14Event
{
    /**
     * @var array<string, string>
     */
    private array $urlTemplates = [];

    /**
     * @var array<string, int>
     */
    private array $maxZooms = [];

    public function register(string $key, string $urlTemplate, int $maxZoom = 20): void
    {
        $this->urlTemplates[$key] = $urlTemplate;
        $this->maxZooms[$key] = $maxZoom;
    }

    /**
     * @return array<string, string>
     */
    public function getTemplates(): array
    {
        return $this->urlTemplates;
    }

    /**
     * @return array<string, int>
     */
    public function getMaxZooms(): array
    {
        return $this->maxZooms;
    }
}
