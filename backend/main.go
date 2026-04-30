package main

import (
	"crypto/sha256"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
)

var flags FlagsDict
var flagsDir []string

type LoginRequest struct{
	Username string `json:"username"`
	Password string `json:"password"`
}

func main() {

	// Add hashes' directories to flags Directory
	flagsDir = append(flagsDir, "flags/org.hash")
	flagsDir = append(flagsDir, "flags/admin.hash")
	// Process directories to capture flags for validation
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

	http.HandleFunc("/admin/login", func(w http.ResponseWriter, r *http.Request) {
		var req LoginRequest
		err := json.NewDecoder(r.Body).Decode(&req)
		if err != nil {
			http.Error(w, "Invalid JSON", http.StatusBadRequest)
			return
		}

		flag2 := "Wrong Password"
		if req.Username == "admin" && req.Password == "ushudntbeseeingthis" {
			flag2 = decryptFlag("flags/admin.enc")
		}

		fmt.Fprintln(w, flag2)
	})

	err := http.ListenAndServe(":8080", nil)

	if err != nil {
		log.Fatal(err)
	}
}