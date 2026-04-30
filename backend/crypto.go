package main

import (
	"io"
	"log"
	"net/http"
	"os"
	"strings"
)

func decryptFlag(fileDir string) string{
	data, err := os.ReadFile(fileDir)

	if err != nil {
		log.Fatal(err)
	}

	resp, err := http.Post(
		"http://treq-crypto:5000/decrypt",
		"application/json",
		strings.NewReader(`{"flag": "` + string(data) + `"}`),
	)

	if err != nil {
		log.Fatal(err)
	}

	defer resp.Body.Close()
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Fatal(err)
	}

	return strings.TrimSpace(string(body))

}