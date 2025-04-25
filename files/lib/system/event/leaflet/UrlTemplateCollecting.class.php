<?php

namespace wcf\event\endpoint;

use wcf\event\IPsr14Event;

final class UrlTemplateCollecting implements IPsr14Event
{
    /**
     * @var array<string, string>
     */
    private array $urlTemplates = [];

    public function register(string $key, string $urlTemplate): void
    {
        $this->urlTemplates[$key] = $urlTemplate;
    }

    /**
     * @return array<string, string>
     */
    public function getTemplates(): array
    {
        return $this->urlTemplates;
    }
}
