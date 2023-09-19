When we have multiple EC2 servers that perform different tasks, we would like to automate the starting and stopping of these using AWS EVENTBRIDGE and AWS Lambda to schedule this automation process in the 
period where our servers are less busy. The purpose of having such architecture is to reduce the compute cost of our EC2 resources. During office ours we can have them on but why leave these servers
on when they have less access.

We will be working with:
a. EC2-instances.
b. AWS lambda functions
c. Amazon EventBridge
d. AWS Simple Email service (SES).

Design: we create an event bridge on a scheduled time to trigger a lambda function. This lambda function starts or turns of our EC2 instances depending on the schedule time. for office hours it turns it on 
and turns it off after office hours. After setting our lambda and EventBridge we configure SES to notify us when instances are entering a start or stop state.

STEPS: 
1. We create a lambda function and name it "eventFunction".
   - use any programming language of your choice, in this project we will be using python as our runtime engine.
   - You can find the python code in the lambda.py file stored in this project directory.
