<?php

namespace wcf\system\form\builder\field;

use wcf\system\exception\SystemException;
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
	 * Weather locate is enabled
	 */
	protected $locate = false;

	/**
	 * @inheritDoc
	 */
	public function __construct()
	{
		$this->label('wcf.global.leaflet.formfield.label');
		$this->description('wcf.global.leaflet.formfield.description');
	}

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
	public function getHtmlVariables()
	{
		$variables = parent::getHtmlVariables();

		$variables['accessUserLocation'] = $this->locate;

		return $variables;
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
			} catch (SystemException $e) {
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
		} catch (SystemException $e) {
		}

		return null;
	}

	/**
	 * Sets weather locate is enabled
	 * @param bool $locate
	 */
	public function locate(bool $locate = true): self
	{
		$this->locate = $locate;

		return $this;
	}
}
