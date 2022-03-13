FROM golang:1.17.3 AS builder

RUN mkdir -p /go/src/github.com/bvwells/kubernetes-secrets 
COPY main.go /go/src/github.com/bvwells/kubernetes-secrets
COPY go.mod /go/src/github.com/bvwells/kubernetes-secrets
COPY go.sum /go/src/github.com/bvwells/kubernetes-secrets
COPY vendor /go/src/github.com/bvwells/kubernetes-secrets/vendor
WORKDIR /go/src/github.com/bvwells/kubernetes-secrets

RUN go build -v -mod=vendor

FROM alpine:3.14.3

RUN mkdir /lib64 && \
    ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

RUN mkdir /app
WORKDIR /app/
COPY --from=builder /go/src/github.com/bvwells/kubernetes-secrets/kubernetes-secrets /app/

RUN addgroup -S kube && adduser -S -g kube kube
RUN chown kube:kube /app
USER kube

CMD ["/app/kubernetes-secrets"]
