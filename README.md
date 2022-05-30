# demo-first-app

This is a sample demo test by passing query string to lambda function through alb - Below is a brief explanation of what we have generated for you:


## Requirements

* Install AWS cli and Configure AWS credential
* Install Terraform


## Setup process

* Configure aws credential using below command
```bash
    $ aws configure
      - provide access key
      - provide secret key
```


## Packaging and deployment

To deploy your application for the first time, run the following in your shell:

```bash

#go to the terraform development directory
$ cd terraform/development/all-script

# initialized terraform
$ terraform init

# check any configuration is right or wrong
$ terraform plan

# apply terraform command for deployment
$ terraform apply
```

You can find your ALB Endpoint URL in the output values displayed after deployment.

## Command Script
* Copy the ALB url
* Run the go command script
```bash
# Go to the utils/commands directory
$ cd utils/commands

# run the go script
$ go run main.go [provide the ALB url]

# for example
$ go run main.go alb-postback-suppresion-dev-625477907.us-east-1.elb.amazonaws.com

# Finally, check the output in cloudwatch


```

