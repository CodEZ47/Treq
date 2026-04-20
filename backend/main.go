package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request){
		fmt.Fprintln(w, "ok")
	})

	http.HandleFunc("/validate", func(w http.ResponseWriter, r *http.Request){
		fmt.Fprintln(w, "flag received")
	})

	fmt.Print("Backend up and Running...")

	err := http.ListenAndServe(":8080", nil)

	if err != nil {
		log.Fatal(err)
	}
}