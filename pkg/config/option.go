package config

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
