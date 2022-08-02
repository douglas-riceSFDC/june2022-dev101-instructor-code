import { LightningElement, api } from 'lwc';
import getRelatedTimecards from '@salesforce/apex/TimecardApprovalController.getRelatedTimecards';

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
    
}