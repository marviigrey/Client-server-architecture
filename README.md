We are going to create a simple web app that tells the time. A simple html,css and js application that users can find out the current time with just a click of a button.
1. we will be creating a launch template because we might want to attah our application with an auto-scaling group incase of failover.
2. we will need an application load-balancer to help us direct and control traffic coming into to our application. we will need to edit the security group of our target group to direct traffic into our loadbalancer SG.
3. Route 53 will also be needed as a domain registrar and a DNS A record.

Step 1: We launch a single instance with the launch template,the template consists of certain configurations such as security groups,key pair and all other configuration needed.
After launching this single instance,we then test if wecan reach the app because we already configured the app in our luanch template using a custom ec2-data-script that can be found in this repo under the launch-template directory.
Ensure that port 80(HTTP) is open because we are working with an apache web app.

Step 2: After testing our application and seeing it work we then move to creating a security group for our load balancer,a target group and an application load balancer.
for the SG of the ALB, we will need to open port 80. so we can map it to the target  group of our instances.

Step 3: We will not be adding any database yet,but we will see it in the next project. after creating the SG for the ALB,the target group and the ALB, we move forward to registering the instance into our newly created target group.
after registering the instances,we go to the sg of that single instance and edit the inbound rule to only receive traffic from our alb SG.
