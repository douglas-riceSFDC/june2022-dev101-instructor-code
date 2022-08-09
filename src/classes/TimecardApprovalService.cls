@RestResource(urlMapping='/Timecard/*')
global with sharing class TimecardApprovalService {

    @HttpPost
    global static TimecardApprovalResponse approveTimecard(TimecardApprovalRequest request) {
        if(request.timecardId != null) {
            List<Timecard__c> timecards = new List<Timecard__c>();
            timecards = [SELECT Id FROM Timecard__c WHERE Id = :request.timecardId];

            if(timecards.size() > 0) {
                Approval.ProcessWorkitemRequest approvalRequest = new Approval.ProcessWorkitemRequest();
                approvalRequest.setComments(request.comments);

                if(request.approvalMessage.toLowerCase() == 'approve') {
                    approvalRequest.setAction('Approve');
                } else if(request.approvalMessage.toLowerCase() == 'reject') {
                    approvalRequest.setAction('Reject');
                } else {
                    return sendErrorMessage('Invalid Action');
                }

                Id workItemId = getWorkitemId(request.timecardId);

                if(workItemId != null) {
                    approvalRequest.setWorkitemId(workItemId);
                    Approval.ProcessResult result = Approval.process(approvalRequest);

                    if(result.isSuccess()) {
                        return sendSuccessMessage();
                    } else {
                        return sendErrorMessage(result.getErrors()[0].getMessage());
                    }

                } else {
                    return sendErrorMessage('No Active Approvals');
                }
            }

        } else {
            return sendErrorMessage('Invalid Timecard ID');
        }

        return sendErrorMessage('There was an issue.');
    }

    private static Id getWorkItemId(Id timecardId) {
        List<ProcessInstanceWorkitem> pendingSubmissions = new List<ProcessInstanceWorkitem>();
        pendingSubmissions = [SELECT Id 
                                FROM ProcessInstanceWorkitem 
                                WHERE ProcessInstance.TargetObjectId = :timecardId];

        for(ProcessInstanceWorkitem p : pendingSubmissions) {
            return p.Id;
        }

        return null;
    }

    private static TimecardApprovalResponse sendSuccessMessage() {
        TimecardApprovalResponse response = new TimecardApprovalResponse();
        response.isSuccess = true;

        return response;
    }

    private static TimecardApprovalResponse sendErrorMessage(String message) {
        TimecardApprovalResponse response = new TimecardApprovalResponse();
        response.errorMessage = message;
        response.isSuccess = false;

        return response;
    }

    global class TimecardApprovalRequest {
        String timecardId;
        String approvalMessage;
        String comments;
    }

    global class TimecardApprovalResponse {
        String errorMessage;
        Boolean isSuccess;
    }
}