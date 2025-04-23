<?php

namespace wcf\system\form\builder\field;

use wcf\system\form\builder\field\validation\FormFieldValidationError;

class LeafletFormField extends AbstractFormField
{
    /**
     * @inheritDoc
     */
    protected $javaScriptDataHandlerModule = 'xXSchrandXx/Core/Form/Builder/Field/LatLng';

    /**
     * @inheritDoc
     */
    protected $templateName = 'shared_leafletFormField';

    /**
     * @inheritDoc
     */
    public function readValue()
    {
        wcfDebug($this->getDocument());

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
            // @see StyleAddForm::readFormParameters()
            if (!\preg_match('~rgba\(\d{1,3}, ?\d{1,3}, ?\d{1,3}, ?(1|1\.00?|0|0?\.[0-9]{1,2})\)~', $this->getValue())) {
                $this->addValidationError(new FormFieldValidationError(
                    'invalid',
                    'wcf.style.colorPicker.error.invalidColor'
                ));
            }
        }
    }
}
