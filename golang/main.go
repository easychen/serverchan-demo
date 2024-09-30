package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
	"strings"
)

func main() {
	data, err := ioutil.ReadFile("../.env")
	if err != nil {
		fmt.Println(err)
		return
	}

	env := string(data)
	m, err := parseEnv(env)
	if err != nil {
		fmt.Println(err)
		return
	}

	key := m["SENDKEY"]

	ret := scSend("主人服务器宕机了", "第一行\n\n第二行", key)
	fmt.Println(ret)
}

func parseEnv(env string) (map[string]string, error) {
	m := make(map[string]string)
	lines := strings.Split(env, "\n")
	for _, line := range lines {
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		parts := strings.Split(line, "=")
		if len(parts) != 2 {
			return nil, fmt.Errorf("Invalid .env format")
		}
		key := strings.TrimSpace(parts[0])
		value := strings.TrimSpace(parts[1])
		m[key] = value
	}
	return m, nil
}

func scSend(text string, desp string, key string) string {
	data := url.Values{}
	data.Set("text", text)
	data.Set("desp", desp)

	// 根据 sendkey 是否以 "sctp" 开头决定 API 的 URL
	var apiUrl string
	if strings.HasPrefix(key, "sctp") {
		apiUrl = fmt.Sprintf("https://%s.push.ft07.com/send", key)
	} else {
		apiUrl = fmt.Sprintf("https://sctapi.ftqq.com/%s.send", key)
	}

	client := &http.Client{}
	req, err := http.NewRequest("POST", apiUrl, strings.NewReader(data.Encode()))
	if err != nil {
		return err.Error()
	}

	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")

	resp, err := client.Do(req)
	if err != nil {
		return err.Error()
	}
	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return err.Error()
	}

	return string(body)
}
