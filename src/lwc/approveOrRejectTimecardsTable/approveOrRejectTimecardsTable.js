import { LightningElement, api } from 'lwc';

export default class ApproveOrRejectTimecardsTable extends LightningElement {
    @api timecards;

    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Status', fieldName: 'Status__c' },
        { label: 'Times Rejected', fieldName: 'Number_of_Times_Rejected__c' }
    ];

    handleRowSelection(event) {
        console.log(event);
    }
}