from flask import Flask, render_template, request, url_for
import requests
import json
import time

from helpers import log_to_cwl

messages = []
IP_TO_SERVE_ON = "0.0.0.0"
PORT = 3829 

# Initialize the Flask application
app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def handle_requests():
    global messages

    if request.method == 'POST':
        r_data = json.loads(request.data.decode("utf-8"))

        hdr = request.headers.get('X-Amz-Sns-Message-Type')
        
        # subscribe to the SNS topic
        if hdr == 'SubscriptionConfirmation' and 'SubscribeURL' in r_data:
            r = requests.get(r_data['SubscribeURL'])
            print(r)
            return 'OK\n'
            
        if hdr == 'Notification':
            msg = "TPZSNSFlaskApp recieved message: " + str(r_data["Message"])
            
            if not log_to_cwl(msg):
                print("Unable to log message to CloudWatchLogs")

            # Insert newest messages to front of list
            messages.insert(0, r_data["Message"])
            return str(len(messages))

    if request.method == 'GET':
        return render_template('SNS.html', message_queue=messages)

# Route that will clear all messages

@app.route('/clear')
def clear():
    global messages

    # Clear all messages and re-render the template
    messages = []
    return render_template('SNS.html', message_queue=messages)

# Run the app :)
if __name__ == '__main__':
    app.run(
        host=IP_TO_SERVE_ON,
        port=PORT,
        threaded=True
    )
