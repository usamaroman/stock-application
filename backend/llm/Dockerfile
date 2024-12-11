FROM ollama/ollama:latest

RUN apt-get update && apt-get install -y curl
RUN curl -fsSL https://ollama.com/install.sh | sh

COPY ./llm/Modefile /Modefile
COPY ./llm/ollama.sh /tmp/run-ollama.sh
WORKDIR /tmp

RUN chmod +x run-ollama.sh \
    && ./run-ollama.sh

EXPOSE 11434
