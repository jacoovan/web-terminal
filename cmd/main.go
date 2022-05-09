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

var (
	errMissEnvHost = fmt.Errorf(`Miss env variable %s`, ENV_HOST)
	errMissEnvPort = fmt.Errorf(`Miss env variable %s`, ENV_PORT)
)

func init() {
	if s, ok := os.LookupEnv(ENV_HOST); s == "" || !ok {
		exit(1, errMissEnvHost)
	}
	if s, ok := os.LookupEnv(ENV_PORT); s == "" || !ok {
		exit(1, errMissEnvPort)
	}
	h = os.Getenv(ENV_HOST)
	p, _ = strconv.Atoi(os.Getenv(ENV_PORT))
	web.SetHostPort(h, p)
}

func main() {
	ctx := context.Background()
	srv := web.NewGin(addr)
	if err := srv.Run(ctx); err != nil {
		exit(1, fmt.Errorf(`srv.Run(err):%v`, err))
	}
}

func exit(errno int, err error) {
	fmt.Println(err)
	os.Exit(errno)
}
