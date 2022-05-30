package main

import (
	"context"
	"os"
	"testing"

	"github.com/aws/aws-lambda-go/events"
	"github.com/stretchr/testify/assert"
)

type mockedALBRequest struct {
	context context.Context
	request events.ALBTargetGroupRequest
	expect  string
	err     error
}

func setEnvVars(es map[string]string) {
	for k, v := range es {
		os.Setenv(k, v)
	}
}
func TestInit(t *testing.T) {

	setEnvVars(map[string]string{
		"region":                "ap-south-1",
		"sqs_name":              "sqs_name",
		"kinesis_firehose_name": "firehose_name",
	})

	MockedDataList := []mockedALBRequest{
		mockedALBRequest{
			context: context.TODO(),
			request: events.ALBTargetGroupRequest{
				QueryStringParameters: map[string]string{
					"network_id":      "plrworldwide_flourish",
					"offer_id":        "5e3776f5-51d9-4e0c-adf9-6864aa06dc5e",
					"clickid":         "21c03a83-845a-4852-a8c5-346da028e262%7C4724768%7C1650457791",
					"advertising_id":  "21c03a83-845a-4852-a8c5-346da028e262",
					"event":           "install",
					"revenue":         "",
					"event_timestamp": "022-04-20%2012%3A31%3A15.341",
					"is_attributed":   "1",
				},
			},
			expect: "{\"status\":\"success\"}",
			err:    nil,
		},
		mockedALBRequest{
			context: context.TODO(),
			request: events.ALBTargetGroupRequest{
				QueryStringParameters: map[string]string{
					"network_id":      "plrworldwide_flourish",
					"offer_id":        "5e3776f5-51d9-4e0c-adf9-6864aa06dc5e",
					"clickid":         "21c03a83-845a-4852-a8c5-346da028e262%7C4724768%7C1650457791",
					"advertising_id":  "21c03a83-845a-4852-a8c5-346da028e262",
					"event":           "install",
					"revenue":         "",
					"event_timestamp": "022-04-20%2012%3A31%3A15.341",
					"is_attributed":   "0",
				},
			},
			expect: "{\"status\":\"success\"}",
			err:    nil,
		},
	}

	for _, testData := range MockedDataList {
		t.Run("ALB query string pass", func(t *testing.T) {
			response, err := handler(testData.context, testData.request)
			assert.IsType(t, testData.err, err)
			assert.Equal(t, testData.expect, response.Body)
		})
	}

}
