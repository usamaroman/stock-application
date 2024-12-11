package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/ollama/ollama/api"
)

var store = map[string]any{
	"gold": nil,
}

type Server struct {
	resChan      chan string
	router       *gin.Engine
	ollamaClient *api.Client
}

func main() {
	var defaultOllamaURL string

	ollamaHost := os.Getenv("OLLAMA_HOST")
	if ollamaHost == "" {
		defaultOllamaURL = "http://localhost:11434/api/chat"
	}

	srv := &Server{
		router: gin.Default(),
	}

	srv.router.POST("/dollar", func(ctx *gin.Context) {
		var req struct {
			From string `json:"from"`
			To   string `json:"to"`
		}

		if err := ctx.ShouldBindJSON(&req); err != nil {
			ctx.JSON(http.StatusInternalServerError, err.Error())
			return
		}

		res, err := fetchDollar(req.From, req.To)
		if err != nil {
			ctx.JSON(http.StatusInternalServerError, err.Error())
			return
		}

		ctx.JSON(http.StatusOK, res)
	})
	srv.router.GET("/health", func(ctx *gin.Context) {
		resp, err := talkToOllama(defaultOllamaURL, Request{
			Model:  "stockmodel",
			Stream: false,
			Messages: []Message{
				{
					Role:    "user",
					Content: "1 + 1",
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
	srv.router.GET("/gold", func(ctx *gin.Context) {
		ctx.JSON(http.StatusOK, store["gold"])
	})

	srv.router.POST("/calculate_dollar", func(ctx *gin.Context) {
		var req struct {
			Duration int `json:"duration"`
		}

		if err := ctx.ShouldBindJSON(&req); err != nil {
			ctx.JSON(http.StatusInternalServerError, err.Error())
			return
		}

		dollars, err := fetchDollar("2024-12-01", "2024-12-11")
		if err != nil {
			ctx.JSON(http.StatusInternalServerError, err.Error())
			return
		}

		log.Println("dollars", dollars)
		msg := fmt.Sprintf("цена доллара сейчас в последнии 11 дней %v, предскажи цену рубля на ближайшие %d месяцeв", dollars, req.Duration)

		log.Println(msg)

		resp, err := talkToOllama(defaultOllamaURL, Request{
			Model:  "stockmodel",
			Stream: false,
			Messages: []Message{
				{
					Role:    "user",
					Content: msg,
				},
			},
		})
		if err != nil {
			ctx.JSON(http.StatusInternalServerError, err.Error())
			return
		}

		log.Println(resp.Message.Content)
		store["gold"] = resp.Message.Content

		str := strings.Trim(strings.Trim(resp.Message.Content, "["), "]")
		prices := strings.Split(str, ",")

		res := make([]int, 0, len(prices))
		for _, p := range prices {
			i, err := strconv.Atoi(p)
			if err != nil {
				ctx.JSON(http.StatusInternalServerError, err.Error())
				return
			}

			res = append(res, i)
		}

		ctx.JSON(http.StatusOK, res)
	})
	srv.router.POST("/calculate_gold", func(ctx *gin.Context) {
		var req struct {
			Amount   float64 `json:"amount"`
			Duration int     `json:"duration"`
		}

		if err := ctx.ShouldBindJSON(&req); err != nil {
			ctx.JSON(http.StatusInternalServerError, err.Error())
			return
		}

		gold, err := fetchGoldPrice()
		if err != nil {
			ctx.JSON(http.StatusInternalServerError, err.Error())
			return
		}

		log.Println("gold price", gold.Price)

		resp, err := talkToOllama(defaultOllamaURL, Request{
			Model:  "stockmodel",
			Stream: false,
			Messages: []Message{
				{
					Role:    "user",
					Content: fmt.Sprintf("цена золота сейчас %.3f в рублях за кг, предскажи цену рубля на ближайшие %d месяцeв", gold.Price, req.Duration),
				},
			},
		})
		if err != nil {
			ctx.JSON(http.StatusInternalServerError, err.Error())
			return
		}

		log.Println(resp.Message.Content)
		store["gold"] = resp.Message.Content

		str := strings.Trim(strings.Trim(resp.Message.Content, "["), "]")
		prices := strings.Split(str, ",")

		res := make([]int, 0, len(prices))
		for _, p := range prices {
			i, err := strconv.Atoi(p)
			if err != nil {
				ctx.JSON(http.StatusInternalServerError, err.Error())
				return
			}

			res = append(res, i)
		}

		ctx.JSON(http.StatusOK, res)
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

type Dollar struct {
	Securities struct {
		Data [][]any `json:"data"`
	} `json:"securities"`
}

type GoldPriceResponse struct {
	Timestamp int64   `json:"timestamp"`
	Price     float64 `json:"price"`
	Currency  string  `json:"currency"`
}

func fetchGoldPrice() (*GoldPriceResponse, error) {
	url := "https://www.goldapi.io/api/XAU/RUB"
	accessToken := "goldapi-5lksm4if7uc1-io"

	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return nil, fmt.Errorf("failed to create request: %w", err)
	}

	req.Header.Set("x-access-token", accessToken)

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("failed to make HTTP request: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("non-200 status code: %d, body: %s", resp.StatusCode, string(body))
	}

	var result GoldPriceResponse
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("failed to read response body: %w", err)
	}
	if err := json.Unmarshal(body, &result); err != nil {
		return nil, fmt.Errorf("failed to parse JSON response: %w", err)
	}

	return &result, nil
}

func fetchDollar(from, to string) ([]float64, error) {
	resp, err := http.Get(fmt.Sprintf("https://iss.moex.com/iss/statistics/engines/futures/markets/indicativerates/securities/USD/RUB.json?from=%s&till=%s&iss.meta=off", from, to))
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	body, err := io.ReadAll(resp.Body)

	if err != nil {
		return nil, err
	}
	var result Dollar
	if err := json.Unmarshal(body, &result); err != nil {
		return nil, err
	}

	res := make([]float64, 0, len(result.Securities.Data))

	for _, d := range result.Securities.Data {
		res = append(res, d[3].(float64))
	}

	return res, nil
}
