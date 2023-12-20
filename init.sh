#!/bin/bash
mkdir cmd  internal scripts log
mkdir -p pkg/config
echo 'package cmd
 
 import (
 "github.com/spf13/cobra"
 )
 
 var rootCmd = &cobra.Command{
 Use:               "",
 Short:             "",
 PersistentPreRun:  func(cmd *cobra.Command, args []string) {},
 PreRun:            func(cmd *cobra.Command, args []string) {},
 Run:               func(cmd *cobra.Command, args []string) {
cmd.Help()
 },
 PostRun:           func(cmd *cobra.Command, args []string) {},
 PersistentPostRun: func(cmd *cobra.Command, args []string) {},
 }
 
 func Execute() error {
 if err := rootCmd.Execute(); err != nil {
 // handle  error
 return err
 }
 return nil
 }
' > cmd/cmd.go
echo 'package cmd

import (
"fmt"

"github.com/spf13/cobra"
)

func init() {
rootCmd.AddCommand(versionCmd)
}

var versionCmd = &cobra.Command{
Use:     "version",
Aliases: []string{"v"},
Short:   "version",
Long:    "All software has versions.",
Run: func(cmd *cobra.Command, args []string) {
fmt.Println("version")
},
}
'  > cmd/version.go
echo 'package main
 
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
'>main.go
echo 'package config
 
 import (
 "fmt"
 
 "github.com/mitchellh/mapstructure"
 "github.com/spf13/viper"
 )
 
 var (
 defaultConfig *config
 )
 
 func init() {
 defaultConfig = NewConfig(WithLoadOnce(true))
 }
 
 type config struct {
 c *viper.Viper
 Options
 }
 
 func NewConfig(opts ...Option) *config {
 cnf := &config{
 c: viper.New(),
 }
 option := Options{}
 for _, opt := range opts {
 opt(&option)
 }
 cnf.Options = option
 return cnf
 }
 
 func Default() *config {
 return defaultConfig
 }
 
func (c *config) SetCnfFileName(filename string) {
c.c.SetConfigFile(filename)
}
 
 func (c *config) Load() error {
 var err error
 if c.Options.loadOnce {
 c.once.Do(func() {
 err = c.c.ReadInConfig()
 })
 return err
 }
 return c.c.ReadInConfig()
 }
 
 func (c *config) GetCnfDefault(key string, defCnf interface{}) interface{} {
 cnf := c.c.Get(key)
 if cnf == nil {
 cnf = defCnf
 }
 return cnf
 }
 
 func (c *config) UnmarshalKey(key string, target interface{}) error {
 return c.c.UnmarshalKey(key, target, func(dc *mapstructure.DecoderConfig) {
 // set DecoderConfig. if not, DecoderConfig default
 })
 }
 
' > pkg/config/config.go
echo 'package config
 
 import "sync"
 
 type Options struct {
 loadOnce bool
 once     sync.Once
 }
 
 type Option func(*Options)
 
 func WithLoadOnce(loadOnce bool) Option {
 return func(o *Options) {
 o.loadOnce = loadOnce
 }
 }
'>pkg/config/option.go
go mod init prometheus-targets-demo
echo '

require (
    github.com/spf13/cobra v1.1.1
    github.com/spf13/viper v1.7.1
)'>> go.mod
go mod tidy
go mod vendor
# /bin/bash init.sh 
