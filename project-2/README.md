When we have multiple EC2 servers performing different tasks, we would like to automate the starting and stopping of these using AWS EVENTBRIDGE and AWS Lambda to schedule this automation process when our servers are less busy. The purpose of having such an architecture is to reduce the computing cost of our EC2 resources. We can have them on during office hours, but why leave these servers
on when they have less access?

We will be working with:
a. EC2-instances.
b. AWS lambda functions
c. Amazon EventBridge
d. AWS Simple Email Service (SES).

Design: we create an event bridge on a scheduled time to trigger a lambda function. This lambda function starts or turns off our EC2 instances depending on the scheduled time. for office hours it turns it on 
and turns it off after office hours. After setting our lambda and EventBridge we configure SES to notify us when instances are entering a start or stop state.

STEPS: 
1. We create a lambda function and name it "eventFunction".
   - use any programming language of your choice, in this project we will be using Python as our runtime engine.
   - The Python code in the lambda.py file is stored in this project directory.
   - NOTE: you are to edit the source and destination of the email, the region, and the instance id in the lambda code.
   - After creating the lambda we move on to creating the eventbridge scheduled task.
2. Go to the management console and open the EventBridge dashboard.
   - click on schedules and create a new one with the name start instance.
   - leave the schedule group as default, move and click on the recurring schedule pattern, and select a cron-based pattern.
   - fill in this pattern in the box: "00 10 ? * MON-FRI *"
   - the above pattern is scheduled for Monday to Friday every 10 am.
   - create a target-API, in this case, will be our lambda function "eventFunction" we created earlier.
   - for the payload: {
    "action": "start_instance"
}
   - review and create the scheduled task.
   - create another schedule for the "stop_instance"
   - follow the same procedure but this time set the payload differently:
     {
    "action": "stop_instance"
}
3. Configure SES:
   - Navigate to the SES Dashboard and create two different identities for the source and destination emails specified in your lambda function.
   - Verify the emails.

Conclusion: With this architecture, we will be saving the cost of EC2 compute services. On days such as weekends when we do not have the need for servers running the event bridge will invoke our lambda function to trigger a stop state for our EC2 instances. 
