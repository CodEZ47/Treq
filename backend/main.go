package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request){
		fmt.Fprintln(w, "OK")
	})

	http.HandleFunc("/validate", func(w http.ResponseWriter, r *http.Request){
		fmt.Fprintln(w, "flag received")
	})

	err := http.ListenAndServe(":8080", nil)

	if err != nil {
		log.Fatal(err)
	}
}