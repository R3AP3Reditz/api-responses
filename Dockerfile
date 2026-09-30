FROM golang:1.26-alpine AS build
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o /out/api-proxy .

FROM alpine:3.22
RUN apk add --no-cache ca-certificates
COPY --from=build /out/api-proxy /usr/local/bin/api-proxy
ENV LISTEN=:8080 \
    DATA_DIR=/data
RUN mkdir -p /data
VOLUME /data
EXPOSE 8080
ENTRYPOINT ["api-proxy"]
