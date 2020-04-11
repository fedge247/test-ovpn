package handlers

import (
	"github.com/gin-gonic/gin"
	"github.com/JamesNguyen9x/test-ovpn/service/autoclean"
	"github.com/JamesNguyen9x/test-ovpn/service/profile"
)

func stopPost(c *gin.Context) {
	prfls := profile.GetProfiles()
	for _, prfl := range prfls {
		prfl.Stop()
	}

	autoclean.CheckAndCleanWatch()

	c.JSON(200, nil)
}
