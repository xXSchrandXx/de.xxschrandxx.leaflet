<?php

namespace wcf\system\form\builder\field;

use wcf\system\form\builder\field\validation\FormFieldValidationError;
use wcf\util\JSON;

class LeafletFormField extends AbstractFormField
{
    /**
     * @inheritDoc
     */
    protected $javaScriptDataHandlerModule = 'WoltLabSuite/Core/Form/Builder/Field/Value';

    /**
     * @inheritDoc
     */
    protected $templateName = 'shared_leafletFormField';

    /**
     * @inheritDoc
     */
    public function readValue()
    {
        if (
            $this->getDocument()->hasRequestData($this->getPrefixedId())
            && \is_string($this->getDocument()->getRequestData($this->getPrefixedId()))
        ) {
            $this->value = $this->getDocument()->getRequestData($this->getPrefixedId());

            if ($this->value === '') {
                $this->value = null;
            }
        }

        return $this;
    }

    /**
     * @inheritDoc
     */
    public function validate()
    {
        parent::validate();

        if ($this->getValue() === null) {
            if ($this->isRequired()) {
                $this->addValidationError(new FormFieldValidationError('empty'));
            }
        } else {
            try {
                $latlng = JSON::decode($this->getValue());
                if (!isset($latlng['lat']) || !isset($latlng['lng'])) {
                    $this->addValidationError(new FormFieldValidationError('invalid'));
                }
            } catch (\Exception $e) {
                $this->addValidationError(new FormFieldValidationError('invalid'));
            }
        }
    }

    /**
     * Returns the value as array of this field or null if no value has been set.
     * @return array|null
     */
    public function getArrayValue()
    {
        if ($this->getValue() === null) {
            return null;
        }
        try {
            return JSON::decode($this->getValue());
        } catch (\Exception $e) {
        }

        return null;
    }
}
