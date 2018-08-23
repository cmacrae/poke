// Copyright 2018 Calum MacRae. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.

package main

import (
	"flag"
	"io"
	"log"
	"os"

	yaml "gopkg.in/yaml.v2"
)

// Verbose output
var verbose bool

func init() {
	flag.BoolVar(&verbose, "v", false, "Print Pushover response stats")
	flag.Parse()
}

// Read data from stdin or a file (as argument)
func readData() (io.Reader, error) {
	var err error
	r := os.Stdin
	if len(os.Args) > 1 {
		lastArg := os.Args[len(os.Args)-1]
		if _, err := os.Stat(lastArg); err == nil {
			r, err = os.Open(lastArg)
			if err != nil {
				return r, err
			}
		}
	}
	return r, err
}

func isEmpty(s string, n string) {
	if s == "" {
		log.Fatalf("No %v provided!", n)
	}
}

func main() {
	input, err := readData()
	if err != nil {
		log.Fatal("There was a problem reading the input data")
	}

	n := pushNotification{}
	if err := yaml.NewDecoder(input).Decode(&n); err != nil {
		log.Fatal(err)
	}

	// Check required parameters
	isEmpty(n.Token, "token")
	isEmpty(n.Recipient, "recipient")
	isEmpty(n.Message, "message")

	if err := n.send(); err != nil {
		log.Fatalf("There was an issue sending the notification:\n%v", err)
	}
}
