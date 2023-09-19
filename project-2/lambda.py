import json
import boto3

region = '<region_name>'
instances = ['<instance_id_1>']
ec2 = boto3.client('ec2', region_name=region)
ses = boto3.client('ses', region_name=region)

def lambda_handler(event, context):
    email_body = ''
    
    if event["action"] == "start_instance":
        try:
            ec2.start_instances(InstanceIds=instances)
            email_body = "Your instance {} has started successfully".format(instances[0])
        except Exception as e:
            email_body = "Your instance {} failed to start: {}".format(instances[0], str(e))
    elif event["action"] == "stop_instance":
        try:
            ec2.stop_instances(InstanceIds=instances)
            email_body = "Your instance {} has stopped successfully".format(instances[0])
        except Exception as e:
            email_body = "Your instance {} failed to stop: {}".format(instances[0], str(e))
    else:
        email_body = "You have sent a wrong payload to Lambda!"
    
    return send_email(email_body)

def send_email(email_body):
    try:
        response = ses.send_email(
            Destination={
                "ToAddresses": ["<to_email_address>"]
            },
            Message={
                "Body": {
                    "Text": {
                        "Charset": "UTF-8",
                        "Data": email_body,
                    }
                },
                "Subject": {
                    "Charset": "UTF-8",
                    "Data": "EC2 Instance Status",
                },
            },
            Source="<source_email_address>"
        )

        return {
            "statusCode": 200,
            "body": json.dumps("Email Sent Successfully. MessageId is: " + response['MessageId'])
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps("Something went wrong while sending the email: " + str(e))
        }
