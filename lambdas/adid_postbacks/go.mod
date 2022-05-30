module github.com/jubelAhmed/aws_golang_sow_projects/demo-first-app/lambda/alb-requests-control

go 1.18

replace influencemobile.com/logging => ../logging

require (
	github.com/aws/aws-lambda-go v1.32.0
	github.com/aws/aws-sdk-go v1.44.22
	github.com/stretchr/testify v1.7.1
	influencemobile.com/logging v0.0.0-00010101000000-000000000000
)

require (
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/jmespath/go-jmespath v0.4.0 // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	gopkg.in/yaml.v3 v3.0.0-20200615113413-eeeca48fe776 // indirect
)
