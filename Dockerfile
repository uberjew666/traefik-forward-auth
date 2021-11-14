FROM golang:1.17-alpine as builder

# Setup
RUN mkdir -p /go/src/github.com/thomseddon/traefik-forward-auth
WORKDIR /go/src/github.com/thomseddon/traefik-forward-auth

# Add libraries
RUN apk add --no-cache git

# Copy & build
ADD . /go/src/github.com/thomseddon/traefik-forward-auth/
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a -installsuffix nocgo -o /traefik-forward-auth github.com/thomseddon/traefik-forward-auth/cmd

# Copy into alpine container
FROM alpine:3.14

RUN apk --update upgrade \
    && apk --no-cache --no-progress add procps \
    && rm -rf /var/cache/apk/*

COPY --from=builder /traefik-forward-auth ./

ENTRYPOINT ["/traefik-forward-auth"]
