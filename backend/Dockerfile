# Use an official Golang image
FROM golang:1.23

WORKDIR /app

# Copy source code
COPY . .

# Install dependencies
RUN go mod tidy

# Build the application
RUN go build -o golang-service main.go

# Expose the application port
EXPOSE 8080

# Run the application
CMD ["./golang-service"]

