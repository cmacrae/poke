// Copyright 2018 Calum MacRae. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.

package main

import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/gregdel/pushover"
)

// Payload sent to Pushover for notifications.
type pushNotification struct {
	Token      string `json:"token" yaml:"token"`
	Recipient  string `json:"recipient" yaml:"recipient"`
	Title      string `json:"title" yaml:"title"`
	Message    string `json:"message" yaml:"message"`
	URL        string `json:"url" yaml:"url"`
	URLTitle   string `json:"url_title" yaml:"url_title"`
	Attachment string `json:"attachment" yaml:"attachment"`
}

// sends a constructed pushNotification
func (p pushNotification) send() error {
	message := &pushover.Message{
		Title:     p.Title,
		Message:   p.Message,
		Timestamp: time.Now().Unix(),
		HTML:      true,
		URL:       p.URL,
		URLTitle:  p.URLTitle,
	}
	app := pushover.New(p.Token)
	recipient := pushover.NewRecipient(p.Recipient)

	if p.Attachment != "" {
		file, err := os.Open(p.Attachment)
		if err != nil {
			log.Fatal(err)
		}
		defer file.Close()

		if err := message.AddAttachment(file); err != nil {
			log.Fatal(err)
		}
	}

	response, err := app.SendMessage(message, recipient)
	if err != nil {
		return err
	}
	if verbose {
		fmt.Println(response)
	}
	return nil
}
