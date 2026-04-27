package main

import (
	"crypto/sha256"
	"fmt"
	"io"
	"log"
	"net/http"
)

var flags FlagsDict
var flagsDir []string

func main() {

	flagsDir = append(flagsDir, "flags/org.hash")
	flags = flagDictBuilder(flagsDir)

	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request){
		fmt.Fprintln(w, "OK")
	})

	http.HandleFunc("/validate", func(w http.ResponseWriter, r *http.Request){
		body, err := io.ReadAll(r.Body)

		if err != nil {
			http.Error(w, "Failed to read request", http.StatusBadRequest)
			return
		}

		hash := fmt.Sprintf("%x", sha256.Sum256([]byte(body)))

		val, exists := flags[hash]

		if !exists {
			fmt.Fprintln(w, "Not a Flag :(")
		}else if val == 2{
			fmt.Fprintln(w, "You already found this flag!")
		}else{
			flags[hash] = 2
			fmt.Fprintln(w, "Flag found!")
		}
		
	})

	err := http.ListenAndServe(":8080", nil)

	if err != nil {
		log.Fatal(err)
	}
}