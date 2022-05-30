package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	logging "influencemobile.com/logging"
)

var (
	logger *logging.Loggers
	sess   *session.Session
	env    env_vars
)

func Sessions(region string) (*session.Session, error) {
	svc, err := session.NewSessionWithOptions(session.Options{
		Config: aws.Config{
			Region: aws.String(region),
		},
	})

	return svc, err
}

type QueryObject struct {
	NetworkId      string `json:"network_id"`
	OfferId        string `json:"offer_id"`
	ClickId        string `json:"clickid"`
	AdvertisingId  string `json:"advertising_id"`
	Event          string `json:"event"`
	Revenue        string `json:"revenue"`
	EventTimestamp string `json:"event_timestamp"`
	IsAttributed   string `json:"is_attributed"`
}

func init() {

	// Create a new logger.
	logger = logging.NewLoggers(os.Stderr, logging.Log_level_debug, 0)

}

func jsonResponse(message string, status string) string {
	response_body := map[string]interface{}{
		"status":  status,
		"message": message,
	}

	result, _ := json.Marshal(response_body)

	return string(result)
}

// func handler(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
func handler(ctx context.Context, request events.ALBTargetGroupRequest) (events.ALBTargetGroupResponse, error) {

	env = NewEnv()

	// store query string to QueryObject variable

	var queryObject QueryObject

	queryObject.NetworkId = request.QueryStringParameters["network_id"]
	queryObject.OfferId = request.QueryStringParameters["offer_id"]
	queryObject.ClickId = request.QueryStringParameters["clickid"]
	queryObject.AdvertisingId = request.QueryStringParameters["advertising_id"]
	queryObject.Event = request.QueryStringParameters["event"]
	queryObject.Revenue = request.QueryStringParameters["revenue"]
	queryObject.EventTimestamp = request.QueryStringParameters["event_timestamp"]
	queryObject.IsAttributed = request.QueryStringParameters["is_attributed"]

	queryJsonData, _ := json.Marshal(queryObject)

	// check attribute value
	// if is_attribute = 0 then send to firehose else is_attribute = 1 then send to sqs

	var (
		response_message   string
		attributed_message string
		err                error
	)

	if queryObject.IsAttributed == "0" {
		response_message, err = firehoseHandler(queryJsonData)
		attributed_message = "unattributed data"
		if err != nil {
			logger.SetFields(logging.Fields{
				"error": fmt.Sprintf("%+v", err)}).Debug(response_message)
			return events.ALBTargetGroupResponse{
				Body:              jsonResponse("unattributed data send error.", "failed"),
				StatusCode:        500,
				StatusDescription: "internal server error",
				IsBase64Encoded:   false,
				Headers:           map[string]string{"Content-Type": "application/json"}}, err
		}

	} else if queryObject.IsAttributed == "1" {
		response_message, err = sqsHandler(queryJsonData)
		attributed_message = "attributed data"
		if err != nil {
			logger.SetFields(logging.Fields{
				"error": fmt.Sprintf("%+v", err)}).Debug(response_message)
			return events.ALBTargetGroupResponse{
				Body:              jsonResponse("attributed data send error.", "failed"),
				StatusCode:        500,
				StatusDescription: "internal server error",
				IsBase64Encoded:   false,
				Headers:           map[string]string{"Content-Type": "application/json"}}, err
		}
	}

	if len(response_message) > 0 {

		log.Printf("%s: %s\n", attributed_message, string(queryJsonData))

		// return success response
		return events.ALBTargetGroupResponse{
			Body:              jsonResponse(response_message, "success"),
			StatusCode:        200,
			StatusDescription: "200 OK",
			IsBase64Encoded:   false,
			Headers:           map[string]string{"Content-Type": "application/json"}}, nil

	}

	return events.ALBTargetGroupResponse{
		Body:              jsonResponse("attributed value not found or invalid", "failed"),
		StatusCode:        204,
		StatusDescription: "204 No Content",
		IsBase64Encoded:   false,
		Headers:           map[string]string{"Content-Type": "application/json"}}, nil

}

func main() {
	lambda.Start(handler)
}
