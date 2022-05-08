package main

import (
	"context"
	"fmt"
	"os"
	"strconv"

	"github.com/jacoovan/web-terminal/interface/web"
)

const (
	addr = ":80"

	ENV_HOST = "HOST"
	ENV_PORT = "PORT"
)

var (
	h string = "127.0.0.1"
	p int    = 8081
)

func init() {
	if s, ok := os.LookupEnv(ENV_HOST); s == "" || !ok {
		return
	}
	if s, ok := os.LookupEnv(ENV_PORT); s == "" || !ok {
		return
	}
	h = os.Getenv(ENV_HOST)
	p, _ = strconv.Atoi(os.Getenv(ENV_PORT))
	web.SetHostPort(h, p)
}

func main() {
	ctx := context.Background()
	srv := web.NewGin(addr)
	if err := srv.Run(ctx); err != nil {
		exit(1, err)
	}
}

func exit(errno int, err error) {
	fmt.Println("err:", err)
	os.Exit(errno)
}
