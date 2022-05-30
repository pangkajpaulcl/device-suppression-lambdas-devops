package main

import "os"

type TypeEnvVar int

const (
	ENV_AWS_REGION TypeEnvVar = iota
	ENV_AWS_SQS_NAME
	ENV_AWS_FIREHOSE_NAME
)

var (
	EnvVars = []string{
		ENV_AWS_REGION:        "region",
		ENV_AWS_SQS_NAME:      "sqs_name",
		ENV_AWS_FIREHOSE_NAME: "kinesis_firehose_name",
	}
)

type env_vars struct {
	region        string
	sqs_name      string
	firehose_name string
}

func NewEnv() env_vars {
	return env_vars{
		region:        getRegion(),
		sqs_name:      getSqsName(),
		firehose_name: getFirehoseName(),
	}
}

func getRegion() string       { return os.Getenv(EnvVars[ENV_AWS_REGION]) }
func getSqsName() string      { return os.Getenv(EnvVars[ENV_AWS_SQS_NAME]) }
func getFirehoseName() string { return os.Getenv(EnvVars[ENV_AWS_FIREHOSE_NAME]) }
