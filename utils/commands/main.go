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

func Contains(sl []string, name string) bool {
	for _, value := range sl {
		if value == name {
			return true
		}
	}
	return false
}

func main() {
	arg := os.Args
	if len(arg) == 1 {
		log.Println("Please, run this command. go run main.go -h")
		return
	}
	if len(arg) == 2 {
		if arg[1] == "-h" {
			log.Println("Please, run this command. go run main.go --alb_host=<alb_host> --file_path=<file_path>")
		} else {
			log.Println("Please, run this command. go run main.go -h")
		}
		return
	}

	albArg := strings.Split(arg[1], "=")
	filePathArg := strings.Split(arg[2], "=")
	albHostName := albArg[1]
	filePath := filePathArg[1]

	// url := fmt.Sprintf("http://%s", albName)
	// /home/hafiz/Desktop/Terraform-DevOps/device-suppression-Dev-ops/utils/files/im_engage_network_prtion_public_postbacks.xlsx

	//f, err := excelize.OpenFile(filePath)
	f, err := excelize.OpenFile(filePath)
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

	arrayQueryString := []string{"network_id", "offer_id", "clickid", "advertising_id", "event", "revenue", "event_timestamp", "is_attributed"}
	rows, err := f.GetRows("Result 1")

	if err != nil {
		log.Println("file column not found %v", err)
		return
	}
	// var param_column_position ints
	for j, row := range rows {
		if j == 0 {
			continue
		}
		for i, colCell := range row {
			if i == 6 {
				queryString := colCell[1 : len(colCell)-1]
				queryStringArray := strings.Split(queryString, ",")
				var query string
				var queryKey string
				for k := 0; k < len(queryStringArray); k++ {
					item := strings.Split(queryStringArray[k], ":")
					if len(item) == 2 {
						if item[0][0] == 32 && item[0][1] == 34 {
							queryKey = strings.TrimSpace(item[0][2 : len(item[0])-1])
						} else if item[0][0] == 34 {
							queryKey = strings.TrimSpace(item[0][1 : len(item[0])-1])
						}
						//log.Println(k+1, queryKey)
						isPresent := Contains(arrayQueryString, queryKey)
						if isPresent {
							//log.Println("matched this ", queryKey)
							query = query + "&" + queryStringArray[k]
						}
					}
				}
				query = strings.Replace(query, ",", "&", -1)
				query = strings.Replace(query, "\"", "", -1)
				query = strings.Replace(query, ":", "=", -1)
				query = strings.Replace(query, " ", "", -1)
				if len(query) > 1 {
					query = query[1:len(query)]
				}
				main_url := fmt.Sprintf("%s?%s", albHostName, query)

				resp, err := http.Get(main_url)

				if err != nil {
					log.Println(err)
					return
				}
				defer resp.Body.Close()

				if resp.StatusCode == 503 {
					log.Printf("503 service temporary unavailable. check host url %s\n", albHostName)
					return
				}

				body, _ := io.ReadAll(resp.Body)

				log.Println(j+1, string(body[:]))
			}
		}
		//break
		log.Println()
	}

}
