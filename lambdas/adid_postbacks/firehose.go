package main

import (
	"log"

	"github.com/aws/aws-sdk-go/service/firehose"
)

func firehosePutRecordBatch(svc *firehose.Firehose, eventData []byte) (*firehose.PutRecordBatchOutput, error) {

	recordsBatchInput := &firehose.PutRecordBatchInput{}
	recordsBatchInput = recordsBatchInput.SetDeliveryStreamName(env.firehose_name)

	records := []*firehose.Record{}

	record := &firehose.Record{Data: eventData}
	records = append(records, record)

	recordsBatchInput = recordsBatchInput.SetRecords(records)

	resp, err := svc.PutRecordBatch(recordsBatchInput)

	return resp, err

}

// this function will work for firehose data tranfer controlling and error handling
func firehoseHandler(queryObj []byte) (string, error) {

	sess, err := Sessions(env.region)

	svc := firehose.New(sess)

	// put data into firehose

	result, err := firehosePutRecordBatch(svc, queryObj)
	log.Println(result)
	// check put record success or not
	if err != nil {
		// logger ==  log print
		return "error found while sending data to firehose", err
	}

	return "data sent to firehose successfully.", nil

}
