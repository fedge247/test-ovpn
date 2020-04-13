package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"sync"
)

func main() {
	wait := &sync.WaitGroup{}

	rootDir, err := filepath.Abs(filepath.Dir(os.Args[0]))
	if err != nil {
		panic(err)
	}

	cmd := exec.Command("taskkill.exe", "/F", "/IM", "fvpn.exe")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
	cmd = exec.Command("taskkill.exe", "/F", "/IM", "fvpn-service.exe")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
	cmd = exec.Command("taskkill.exe", "/F", "/IM", "openvpn.exe")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
	cmd = exec.Command(filepath.Join(rootDir, "nssm.exe"),
		"stop", "fvpn")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
	cmd = exec.Command("taskkill.exe", "/F", "/IM", "fvpn.exe")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
	cmd = exec.Command("taskkill.exe", "/F", "/IM", "fvpn-service.exe")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
	cmd = exec.Command("taskkill.exe", "/F", "/IM", "openvpn.exe")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()

	wait.Add(1)
	go func() {
		defer wait.Done()

		cmd := exec.Command(filepath.Join(rootDir, "tuntap", "tuntap.exe"),
			"uninstall")
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr
		cmd.Run()
		cmd = exec.Command(filepath.Join(rootDir, "tuntap", "tuntap.exe"),
			"install")
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr
		cmd.Run()
		cmd = exec.Command(filepath.Join(rootDir, "tuntap", "tuntap.exe"),
			"install")
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr
		cmd.Run()
		cmd = exec.Command(filepath.Join(rootDir, "tuntap", "tuntap.exe"),
			"install")
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr
		cmd.Run()
		cmd = exec.Command(filepath.Join(rootDir, "tuntap", "tuntap.exe"),
			"install")
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr
		cmd.Run()
		cmd = exec.Command(filepath.Join(rootDir, "tuntap", "tuntap.exe"),
			"install")
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr
		cmd.Run()
		cmd = exec.Command(filepath.Join(rootDir, "tuntap", "tuntap.exe"),
			"install")
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr
		cmd.Run()
		cmd = exec.Command(filepath.Join(rootDir, "tuntap", "tuntap.exe"),
			"install")
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr
		cmd.Run()
	}()

	cmd = exec.Command(filepath.Join(rootDir, "nssm.exe"),
		"stop", "fvpn")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
	cmd = exec.Command(filepath.Join(rootDir, "nssm.exe"),
		"remove", "fvpn", "confirm")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
	cmd = exec.Command(filepath.Join(rootDir, "nssm.exe"),
		"stop", "fvpn")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
	cmd = exec.Command("taskkill.exe", "/F", "/IM", "fvpn.exe")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
	cmd = exec.Command("taskkill.exe", "/F", "/IM", "fvpn-service.exe")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
	cmd = exec.Command(filepath.Join(rootDir, "nssm.exe"), "install",
		"fvpn", filepath.Join(rootDir, "fvpn-service.exe"))
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
	cmd = exec.Command("sc.exe", "config", "fvpn",
		fmt.Sprintf(`binPath="%s"`, filepath.Join(rootDir, "nssm.exe")))
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
	cmd = exec.Command(filepath.Join(rootDir, "nssm.exe"),
		"set", "fvpn", "DisplayName", "FVPN Helper Service")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
	cmd = exec.Command(filepath.Join(rootDir, "nssm.exe"),
		"set", "fvpn", "Start", "SERVICE_AUTO_START")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
	cmd = exec.Command(filepath.Join(rootDir, "nssm.exe"),
		"set", "fvpn", "AppStdout",
		"C:\\ProgramData\\FVPN\\service.log")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
	cmd = exec.Command(filepath.Join(rootDir, "nssm.exe"),
		"set", "fvpn", "AppStderr",
		"C:\\ProgramData\\FVPN\\service.log")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
	cmd = exec.Command(filepath.Join(rootDir, "nssm.exe"),
		"set", "fvpn", "Start", "SERVICE_AUTO_START")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
	cmd = exec.Command(filepath.Join(rootDir, "nssm.exe"),
		"start", "fvpn")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()

	wait.Wait()
}
