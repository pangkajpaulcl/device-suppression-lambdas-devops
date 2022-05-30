package main

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/sqs"
)

// get SQS queue url for sending message
func GetQueueURL(sess *session.Session, queue string) (*sqs.GetQueueUrlOutput, error) {
	sqsClient := sqs.New(sess)

	result, err := sqsClient.GetQueueUrl(&sqs.GetQueueUrlInput{
		QueueName: &queue,
	})

	if err != nil {
		return nil, err
	}

	return result, nil
}

// this function is work for sending message to SQS
func SendSqsMessage(sess *session.Session, queueUrl string, messageBody string) error {
	sqsClient := sqs.New(sess)

	_, err := sqsClient.SendMessage(&sqs.SendMessageInput{
		DelaySeconds: aws.Int64(10),
		QueueUrl:     &queueUrl,
		MessageBody:  aws.String(messageBody),
	})
	return err

}

// this function will handle the SQS message processing and error controlling
func sqsHandler(alb_event []byte) (string, error) {

	// log.Println(os.Getenv(EnvVars[ENV_AWS_REGION]))

	sess, _ := Sessions(env.region)

	urlRes, err := GetQueueURL(sess, env.sqs_name)

	if err != nil {
		return "got an error while trying to get queue url", err
	}

	err = SendSqsMessage(sess, *urlRes.QueueUrl, string(alb_event))

	if err != nil {
		return "got an error while trying to send message to queue.", err
	}

	return "data sent to SQS successfully.", nil
}
