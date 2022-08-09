import { LightningElement, api } from 'lwc';

export default class ApproveOrRejectTimecardsTable extends LightningElement {
    @api timecards;

    selectedTimecards = [];

    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Status', fieldName: 'Status__c' },
        { label: 'Times Rejected', fieldName: 'Number_of_Times_Rejected__c' }
    ];

    get isButtonDisabled() {
        return this.selectedTimecards.length === 0;
    }

    handleRowSelection(event) {
        let selectedRows = event.detail.selectedRows;
        console.log(JSON.stringify(selectedRows));

        this.selectedTimecards = selectedRows;
    }

    rejectSelectedTimecards() {
        console.log('firing event');
        let eventPayload = {
            timecards: this.selectedTimecards
        };

        const rejectTimecardsEvent = new CustomEvent('rejecttimecards', {
            detail: eventPayload
        });

        this.dispatchEvent(rejectTimecardsEvent);
    }

    approveSelectedTimecards() {
        console.log('firing event');
        let eventPayload = {
            timecards: this.selectedTimecards
        };

        const approveTimecardsEvent = new CustomEvent('approvetimecards', {
            detail: eventPayload
        });
        
        this.dispatchEvent(approveTimecardsEvent);
    }
}