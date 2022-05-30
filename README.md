# device-suppression-lambdas-devops


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
$ cd terraform/development
- you have to provision all terraform directory under this directory
- firstly, you have to crate VPC, then Security Group
- Next, deploy lambda, then sqs, firehose, alb
- go all directory sequentially and apply terraform command
- there are lots of dependency here, so sometime need to provide some created services arn to other serviced during deploy
- Now, apply terraform command sequentially
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
$ go run main.go --alb_host=<alb_host> --file_path=<full_path>

# for example
$ go run main.go -alb_host=http://alb-postback-suppresion-dev-625477907.us-east-1.elb.amazonaws.com --file-path=/home/jubel/Documents/files/im_engage_network_prtion_public_postbacks.xlsx

# Finally, check the output in cloudwatch


```

