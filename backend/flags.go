package main

import (
	"log"
	"os"
	"strings"
)

type FlagsDict map[string]int

func loadHash(fileDir string) string{
	data, err := os.ReadFile(fileDir)
	if err != nil {
		log.Fatal(err)
	}

	flag := strings.TrimSpace(string(data))

	return flag
}

func flagDictBuilder(l []string) FlagsDict{
	flagsDict := make(FlagsDict)
	for _, s := range l{
		hashedVal := loadHash(s)
		flagsDict[hashedVal] = 1
	}
	return flagsDict
}

