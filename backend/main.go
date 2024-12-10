package main

import (
	"bytes"
	"encoding/json"
	"log"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/ollama/ollama/api"
)

type Server struct {
	resChan      chan string
	router       *gin.Engine
	ollamaClient *api.Client
}

const defaultOllamaURL = "http://localhost:11434/api/chat"

func main() {
	srv := &Server{
		router: gin.Default(),
	}

	srv.router.GET("/health", func(ctx *gin.Context) {
		resp, err := talkToOllama(defaultOllamaURL, Request{
			Model:  "llama3.2",
			Stream: false,
			Messages: []Message{
				{
					Role:    "user",
					Content: "give only number, 1 + 1",
				},
			},
		})
		if err != nil {
			ctx.JSON(http.StatusInternalServerError, err.Error())
			return
		}

		log.Println(resp.Message.Content)
		ctx.JSON(http.StatusOK, resp.Message.Content)
	})

	if err := srv.router.Run(":8080"); err != nil {
		log.Fatal(err)
	}
}

type Request struct {
	Model    string    `json:"model"`
	Messages []Message `json:"messages"`
	Stream   bool      `json:"stream"`
}

type Message struct {
	Role    string `json:"role"`
	Content string `json:"content"`
}

type Response struct {
	Model              string    `json:"model"`
	CreatedAt          time.Time `json:"created_at"`
	Message            Message   `json:"message"`
	Done               bool      `json:"done"`
	TotalDuration      int64     `json:"total_duration"`
	LoadDuration       int       `json:"load_duration"`
	PromptEvalCount    int       `json:"prompt_eval_count"`
	PromptEvalDuration int       `json:"prompt_eval_duration"`
	EvalCount          int       `json:"eval_count"`
	EvalDuration       int64     `json:"eval_duration"`
}

func talkToOllama(url string, ollamaReq Request) (*Response, error) {
	js, err := json.Marshal(&ollamaReq)
	if err != nil {
		return nil, err
	}
	client := http.Client{}
	httpReq, err := http.NewRequest(http.MethodPost, url, bytes.NewReader(js))
	if err != nil {
		return nil, err
	}
	httpResp, err := client.Do(httpReq)
	if err != nil {
		return nil, err
	}
	defer httpResp.Body.Close()
	ollamaResp := Response{}
	err = json.NewDecoder(httpResp.Body).Decode(&ollamaResp)
	return &ollamaResp, err
}
