data "http" "cblogin" {
  url = "https://cognito-idp.eu-north-1.amazonaws.com/"
  method = "POST"
  request_headers = {
    Accept = "application/json"
    Content-Type = "application/x-amz-json-1.1"
    X-Amz-Target = "AWSCognitoIdentityProviderService.InitiateAuth" 
  }
  request_body = <<EOT
      {
        "AuthParameters": {
          "USERNAME": "${var.cb_username}",
          "PASSWORD": "${var.cb_password}"
        },
        "AuthFlow": "USER_PASSWORD_AUTH",
        "ClientId": "54g4h9tpulnnkmhivgn5nipjki"
      }
  EOT
  
  lifecycle {
    postcondition {
      condition = contains([200], self.status_code)
      error_message = "Login to CanaryBit failed! Check your credentials and try again."
    }
  }
}

data "http" "my-public-ip" {
  url = "https://ipv4.icanhazip.com"
}