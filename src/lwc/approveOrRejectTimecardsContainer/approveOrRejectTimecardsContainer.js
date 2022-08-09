import { LightningElement, api } from 'lwc';
import getRelatedTimecards from '@salesforce/apex/TimecardApprovalController.getRelatedTimecards';
import createNewTimecard from '@salesforce/apex/TimecardApprovalController.createNewTimecard';
import rejectTimecards from '@salesforce/apex/TimecardApprovalController.rejectTimecards';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ApproveOrRejectTimecardsContainer extends LightningElement {
    @api recordId;

    timecards;
    modalShown = false;

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

    toggleModal() {
        this.modalShown = !this.modalShown;
    }

    handleSuccess(event) {
        this.dispatchEvent(new ShowToastEvent({
            title: 'Success!',
            message: 'Timecard ' + event.detail.id + ' created successfully!',
            variant: {label: 'success', value: 'success' },
        }));
    }

    handleRejectTimecards(event) {
        console.log('handling event');
        let timecardsToBeRejected = event.detail.timecards;

        console.log('timecards to be rejected');
        console.log(JSON.parse(JSON.stringify(timecardsToBeRejected)));

        rejectTimecards({ timecards: timecardsToBeRejected })
            .then(apexResponse => {
                console.log('reject successful');
                // close the modal
                this.modalShown = false;
            })
            .catch(error => {
                console.warn(error);
            });
    }
}