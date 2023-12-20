package main
 
 import (
 "prometheus-targets-demo/cmd"
 "log"
 )
 
 func main() {
 if  err :=cmd.Execute();err != nil {
 // handle  err 
 log.Fatal(err)
 }
 }

