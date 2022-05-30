package main

import (
	"context"
	"errors"
	"log"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type Message struct {
	MessageId string `json:"MessageId"`
	Message   string `json:"Message"`
}

func HandleRequest(ctx context.Context, event events.SQSEvent) (string, error) {

	if len(event.Records) <= 0 {
		log.Printf("data not available\n")
		return "no data found", errors.New("error: data not available")
	}

	success := false
	// this is working for getting all queue records data form SQS.
	for _, message := range event.Records {
		msg := Message{MessageId: message.MessageId, Message: message.Body}
		log.Printf("sqs call with %s\n", msg.Message)
		success = true
	}

	if success {
		return "sqs log create successfully", nil
	}

	return "sqs log create error", errors.New("log create error from SQS")
}

func main() {
	lambda.Start(HandleRequest)
}
