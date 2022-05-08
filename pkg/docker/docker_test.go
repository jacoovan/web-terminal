package docker_test

import (
	"context"
	"encoding/json"
	"fmt"
	"testing"

	"github.com/jacoovan/web-terminal/pkg/docker"
)

func TestListDocker(t *testing.T) {
	ctx := context.Background()
	list, err := docker.NewDocker().List(ctx)
	if err != nil {
		t.Fatal("err:", err)
	}
	b, _ := json.Marshal(list)
	fmt.Println("list", string(b))
}
