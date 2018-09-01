import boto3, botocore
import time

from config import CWL_GROUP, CWL_STREAM, CWL_KEY, CWL_SECRET

CWL = boto3.client(
    'logs',
    aws_access_key_id=CWL_KEY,
    aws_secret_access_key=CWL_SECRET,
    region_name='eu-central-1'
)

def log_to_cwl( message ): 
    response = CWL.describe_log_streams(
        logGroupName=CWL_GROUP,
        logStreamNamePrefix=CWL_STREAM,
        limit=1
    )

    stkn=None
    if response["logStreams"] and response["logStreams"][0]:
        stream_info = response["logStreams"][0]
        if "uploadSequenceToken" in stream_info.keys():
            stkn = str(response["logStreams"][0]["uploadSequenceToken"])

    timestamp = int(round(time.time() * 1000))

    if message:
        if stkn:
            response = CWL.put_log_events(
                logGroupName=CWL_GROUP,
                logStreamName=CWL_STREAM,
                logEvents=[
                    {
                        'timestamp': timestamp,
                        'message': str(message)
                    }
                ],
                sequenceToken=stkn
            )
        else:
            response = CWL.put_log_events(
                logGroupName=CWL_GROUP,
                logStreamName=CWL_STREAM,
                logEvents=[
                    {
                        'timestamp': timestamp,
                        'message':  time.strftime('%Y-%m-%d %H:%M:%S') + " : " + str(message)
                    }
                ]
            )

        if "nextSequenceToken" in response.keys():
            return True
        else:
            print("No sequence token in response")
            return False

    else:
        print("No message")
        return False
