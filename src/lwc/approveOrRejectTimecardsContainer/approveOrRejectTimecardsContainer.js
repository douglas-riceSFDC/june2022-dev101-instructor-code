import { LightningElement, api, wire } from 'lwc';
import getRelatedTimecards from '@salesforce/apex/TimecardApprovalController.getRelatedTimecards';
import createNewTimecard from '@salesforce/apex/TimecardApprovalController.createNewTimecard';
import rejectTimecards from '@salesforce/apex/TimecardApprovalController.rejectTimecards';
import approveTimecards from '@salesforce/apex/TimecardApprovalController.approveTimecards';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class ApproveOrRejectTimecardsContainer extends LightningElement {
    @api recordId;

    timecards;
    timecardsResult;

    @wire(getRelatedTimecards, { projectId: '$recordId' })
    wiredTimecards(response) {
        this.timecardsResult = response;

        if(response.data) {
            this.timecards = response.data;
            this.error = undefined;
        }
        else if(response.error) {
            this.error = response.error;
            this.timecards = undefined;
        }
    }


    modalShown = false;

    connectedCallback() {
        // getRelatedTimecards( { projectId: this.recordId } )
        //     .then(timecards => {
        //         console.log(timecards);
        //         this.timecards = timecards;
        //     })
        //     .catch(error => {
        //         console.warn(error);
        //     });
    }
    
    createTimecard() {
        createNewTimecard({
            projectId: this.recordId
        })
        .then(timecard => {
            console.log(timecard);
            return refreshApex(this.timecardsResult);
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
                return refreshApex(this.timecardsResult);
            })
            .catch(error => {
                console.warn(error);
            });
    }

    handleApproveTimecards(event) {
        console.log('handling event');
        let selectedTimecards = event.detail.timecards;

        approveTimecards( { timecards: selectedTimecards })
            .then(response => {
                console.log('timecards approved successfully');
                return refreshApex(this.timecardsResult);
            })
            .catch(error => {
                console.error(error);
            });
    }
}