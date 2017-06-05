package main

import (
  "log"
  "os"
  "os/exec"
  "io/ioutil"
  "fmt"
)

func ParseArguments() (string, string, string) {
  var keyPath, password, filePath string
	for idx, param := range os.Args {
		if param == "/f" {
			keyPath = os.Args[idx+1]
		}
		if param == "/p" {
			password = os.Args[idx+1]
		}
		if idx == (len(os.Args) - 1) {
			filePath = param
		}
	}

  // if the important commands aren't set we're done
	if keyPath == "" {
		log.Fatal("keyPath not set")
	}
	if password == "" {
		log.Fatal("password not set")
	}
	if filePath == "" {
		log.Fatal("file to sign path not set")
	}

  return keyPath, password, filePath
}

func main() {
  // Parse command line arguments from signtool.exe so we can map it to
  // osslsigncode paramaters
  keyPath, password, filePath := ParseArguments()

  // set the command line args for SHA1 signing via osslsigncode
  args := []string{
    filePath,
    keyPath,
    password}

  // sign the code for sha1
  cmd := exec.Command("/usr/local/bin/osslsign.sh", args...)
  stderr, err := cmd.StderrPipe()
  if err != nil {
    log.Fatal(err)
  }

  if err = cmd.Start(); err != nil {
    log.Fatal(err)
  }

  slurp, _ := ioutil.ReadAll(stderr)
  fmt.Printf("%s\n", slurp)
}
