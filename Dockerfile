FROM golang:1.17.3 AS builder

RUN mkdir -p /go/src/github.com/bvwells/kubernetes-secrets 
COPY . /go/src/github.com/bvwells/kubernetes-secrets
WORKDIR /go/src/github.com/bvwells/kubernetes-secrets

#ßRUN go mod vendor
RUN go build -v -mod=vendor

RUN ls /go/src/github.com/bvwells/kubernetes-secrets

FROM alpine:3.14.3

RUN apk add --update ca-certificates mailcap && \
    mkdir /lib64 && \
    ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
RUN mkdir /app
WORKDIR /app/
COPY --from=builder /go/src/github.com/bvwells/kubernetes-secrets/kubernetes-secrets /app/
CMD ["/app/kubernetes-secrets"]


