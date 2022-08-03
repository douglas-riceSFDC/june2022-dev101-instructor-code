import { LightningElement, api } from 'lwc';
import getRelatedTimecards from '@salesforce/apex/TimecardApprovalController.getRelatedTimecards';
import createNewTimecard from '@salesforce/apex/TimecardApprovalController.createNewTimecard';

export default class ApproveOrRejectTimecardsContainer extends LightningElement {
    @api recordId;

    timecards;

    connectedCallback() {
        getRelatedTimecards( { projectId: this.recordId } )
            .then(timecards => {
                console.log(timecards);
                this.timecards = timecards;
            })
            .catch(error => {
                console.warn(error);
            });
    }
    
    createTimecard() {
        createNewTimecard({
            projectId: this.recordId
        })
        .then(timecard => {
            console.log(timecard);
        })
        .catch(error => {
            console.warn(error);
        });
    }
}