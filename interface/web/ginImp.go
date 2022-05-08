package web

import (
	"context"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jacoovan/web-terminal/pkg/docker"
)

type ginImp struct {
	addr   string
	engine *gin.Engine
	cli    docker.Docker
}

func NewGin(addr string, opts ...Option) Gin {
	c := &ginImp{
		addr:   addr,
		engine: gin.Default(),
		cli:    docker.NewDocker(),
	}

	for _, opt := range opts {
		opt.apply(c)
	}
	return c
}

func (c *ginImp) Run(ctx context.Context) error {
	c.initRouter()
	if err := c.engine.Run(c.addr); err != nil {
		return err
	}
	return nil
}

func (c *ginImp) initRouter() Gin {
	engine := c.engine
	engine.Handle(http.MethodGet, `/index`, c.Index)
	engine.Handle(http.MethodGet, `/list`, c.List)
	engine.LoadHTMLGlob("config/html/*")
	return c
}

func (c *ginImp) List(ctx *gin.Context) {
	list, err := c.cli.List(ctx)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, newCommonResp(http.StatusInternalServerError, false, "error", nil))
		return
	}
	data := map[string]interface{}{
		"total": len(list),
		"list":  list,
	}
	ctx.JSON(http.StatusOK, newCommonResp(http.StatusOK, true, "ok", data))
}

var (
	h string = "127.0.0.1"
	p uint   = 8081
)

func SetHostPort(host string, port int) {
	h = host
	p = uint(port)
}

func (c *ginImp) Index(ctx *gin.Context) {
	list, err := c.cli.List(ctx)
	if err != nil {
		list = []docker.Container{}
	}
	for i := range list {
		list[i].Host = h
		list[i].Port = p
	}
	ctx.HTML(http.StatusOK, "index.html", list)
}
