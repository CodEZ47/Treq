# Mutli Stage Build

FROM golang:1.26-alpine AS builder
WORKDIR /app
COPY ./go.mod ./
# COPY ./go.sum ./
COPY . .
RUN go mod download
RUN go build -o server .


FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/server .
CMD ["./server"]


