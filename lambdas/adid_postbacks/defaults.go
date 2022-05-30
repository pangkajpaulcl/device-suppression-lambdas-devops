package main

const (
	log_msg_end = iota + 100
	log_msg_begin
	log_msg_is_attributed_invalid_error
	log_msg_sqs_send_error
	log_msg_firehose_send_error
)

var (
	LogMsgTxt = []string{
		log_msg_begin:                       "begin",
		log_msg_end:                         "end",
		log_msg_is_attributed_invalid_error: "isAttributed value not found.",
		log_msg_sqs_send_error:              "data send to sqs failed.",
		log_msg_firehose_send_error:         "data send to firehose failed.",
	}
)
