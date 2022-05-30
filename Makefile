.PHONY: apply

apply-dev:
	cd terraform/development/all-script && terraform init && terraform apply

# destroy-dev:
# 	cd terraform/development && terraform destroy

# destroy-security-group:
# 	cd terraform/development/security-groups && terraform destroy

# destroy-alb:
# 	cd terraform/development/alb && terraform destroy

# destroy-vpc:
# 	cd terraform/development/vpc/us-east-01 && terraform destroy

# destroy-all: destroy-security-group destroy-alb destroy-vpc

# plan-dev:
# 	cd terraform/development && terraform plan

build-lambda1:
	cd lambdas/adid_postbacks && go build -o main

build-lambda2:
	cd lambdas/adid_postbacks_attributed && go build -o main

build-lambda3:
	cd lambdas/adid_postbacks_unattributed && go build -o main

build-all: build-lambda1 build-lambda2 build-lambda3

run-command-script:
	cd utils/commands && go run main.go $(url)



