package handlers

import (
	"github.com/Sirupsen/logrus"
	"github.com/gin-gonic/gin"
	"github.com/JamesNguyen9x/test-ovpn/service/profile"
)

func restartPost(c *gin.Context) {
	logrus.Warn("handlers: Restarting...")

	profile.RestartProfiles(false)

	c.JSON(200, nil)
}
