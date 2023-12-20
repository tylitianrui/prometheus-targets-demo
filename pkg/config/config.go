package config

import (
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
