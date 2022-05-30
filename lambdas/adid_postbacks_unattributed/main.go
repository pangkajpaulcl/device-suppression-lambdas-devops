package main

import (
	"encoding/base64"
	"encoding/json"
	"fmt"
	"log"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

// type KinesisFirehoseEventRecordData struct {
// 	CustomerId string `json:"customerId"`
// }
// type JsonEvents []JsonEvent

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

func handleRequest(evnt events.KinesisFirehoseEvent) (events.KinesisFirehoseResponse, error) {

	var response events.KinesisFirehoseResponse

	var header_list = make(map[string]string)

	for _, record := range evnt.Records {

		var transformedRecord events.KinesisFirehoseResponseRecord
		transformedRecord.RecordID = record.RecordID
		transformedRecord.Result = events.KinesisFirehoseTransformedStateOk

		var metaData events.KinesisFirehoseResponseRecordMetadata

		var eventRecordData QueryObject

		partitionKeys := make(map[string]string)

		json.Unmarshal(record.Data, &eventRecordData)

		log.Printf("firehose call with %s\n", record.Data)

		partitionKeys["network_id"] = eventRecordData.NetworkId

		metaData.PartitionKeys = partitionKeys

		transformedRecord.Metadata = metaData

		var csv_data string
		network_id_key := eventRecordData.NetworkId

		if _, ok := header_list[network_id_key]; !ok {
			header_list[network_id_key] = network_id_key
			csv_data = fmt.Sprintf("%s,%s,%s.%s,%s,%s,%s,%s\n%s,%s,%s.%s,%s,%s,%s,%s\n", "network_id", "offer_id", "clickid", "advertising_id", "event", "revenue", "event_timestamp", "is_attributed", eventRecordData.NetworkId, eventRecordData.OfferId, eventRecordData.ClickId, eventRecordData.AdvertisingId, eventRecordData.Event, eventRecordData.Revenue, eventRecordData.EventTimestamp, eventRecordData.IsAttributed)
		} else {
			csv_data = fmt.Sprintf("%s,%s,%s.%s,%s,%s,%s,%s\n", eventRecordData.NetworkId, eventRecordData.OfferId, eventRecordData.ClickId, eventRecordData.AdvertisingId, eventRecordData.Event, eventRecordData.Revenue, eventRecordData.EventTimestamp, eventRecordData.IsAttributed)
		}

		str := base64.StdEncoding.EncodeToString([]byte(csv_data))

		data, err := base64.StdEncoding.DecodeString(str)

		if err != nil {
			log.Fatal("error:", err)
		}

		record.Data = data

		transformedRecord.Data = record.Data

		response.Records = append(response.Records, transformedRecord)

	}
	return response, nil
}

func main() {
	lambda.Start(handleRequest)
}
