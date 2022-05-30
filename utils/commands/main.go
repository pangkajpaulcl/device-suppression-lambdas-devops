package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"strings"

	"github.com/xuri/excelize/v2"
)

func main() {

	arg := os.Args[1]

	url := fmt.Sprintf("http://%s", arg)

	f, err := excelize.OpenFile("../files/im_engage_network_prtion_public_postbacks.xlsx")
	if err != nil {
		log.Println("file opening error %v", err)
		return
	}
	defer func() {
		// Close the spreadsheet.
		if err := f.Close(); err != nil {
			log.Println("file closing error %v", err)
		}
	}()

	rows, err := f.GetRows("Result 1")

	if err != nil {
		log.Println("file column not found %v", err)
		return
	}

	// var param_column_position ints
	for j, row := range rows {
		for i, colCell := range row {

			if i == 6 {
				query_string := colCell[1 : len(colCell)-1]

				query_string = strings.Replace(query_string, ",", "&", -1)
				query_string = strings.Replace(query_string, "\"", "", -1)
				query_string = strings.Replace(query_string, ":", "=", -1)
				query_string = strings.Replace(query_string, " ", "", -1)

				main_url := fmt.Sprintf("%s?%s", url, query_string)

				resp, err := http.Get(main_url)

				if err != nil {
					log.Println(err)
				}
				defer resp.Body.Close()

				body, _ := io.ReadAll(resp.Body)

				log.Println(j+1, string(body[:]))

			}

		}
		log.Println()
	}

}
