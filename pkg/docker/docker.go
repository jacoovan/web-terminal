package docker

import (
	"context"
	"strings"

	"github.com/docker/docker/api/types"
	"github.com/docker/docker/client"
)

type Docker interface {
	List(ctx context.Context) (list []Container, err error)
}

type dockerImp struct {
	cli *client.Client
}

func NewDocker() Docker {
	cli, err := client.NewClientWithOpts(client.FromEnv)
	if err != nil {
		return nil
	}

	c := &dockerImp{
		cli: cli,
	}
	return c
}

func (c *dockerImp) List(ctx context.Context) (list []Container, err error) {
	opts := types.ContainerListOptions{}
	tempList, err := c.cli.ContainerList(ctx, opts)
	if err != nil {
		return nil, err
	}

	list = make([]Container, len(tempList))
	for i, v := range tempList {
		list[i].ID = v.ID[:8]
		list[i].Name = strings.Join(v.Names, " ")
		list[i].Image = v.Image
		list[i].State = v.State
		list[i].Status = v.Status
		list[i].CreatedAt = v.Created
	}
	return list, nil
}

type Container struct {
	ID        string `json:"id"`
	Name      string `json:"name"`
	Image     string `json:"image"`
	State     string `json:"state"`
	Status    string `json:"status"`
	Host      string `json:"host"`
	Port      uint   `json:"port"`
	CreatedAt int64  `json:"created_at"`
}
