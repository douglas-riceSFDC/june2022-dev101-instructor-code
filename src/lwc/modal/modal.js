import { LightningElement, api } from 'lwc';

export default class Modal extends LightningElement {
    @api label;

    _modalShownOverride;

    @api 
    get modalShownOverride() {
        return this._modalShownOverride;
    }
    set modalShownOverride(value) {
        if(value) {
            this.toggleModal();
        }
        this._modalShownOverride = value;
    }

    modalShown = false;

    toggleModal() {
        this.modalShown = !this.modalShown;
    }
}