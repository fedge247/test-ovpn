package handlers

import (
	"github.com/gin-gonic/gin"
	"github.com/JamesNguyen9x/test-ovpn/service/profile"
)

type statusData struct {
	Status bool `json:"status"`
}

func statusGet(c *gin.Context) {
	data := &statusData{
		Status: profile.GetStatus(),
	}

	c.JSON(200, data)
}
