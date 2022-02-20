FROM golang:1.7.3 AS build
WORKDIR /build
COPY main.go .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

FROM alpine:latest AS final
WORKDIR /app/
COPY --from=build /build/main .
CMD ["./main"]