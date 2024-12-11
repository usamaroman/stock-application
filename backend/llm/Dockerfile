FROM ollama/ollama:latest

RUN apt-get update && apt-get install -y curl
RUN curl -fsSL https://ollama.com/install.sh | sh

WORKDIR /app
COPY ./llm/Modefile /Modefile

CMD ["ollama", "create", "stockmodel", "-f", "/Modefile"]
