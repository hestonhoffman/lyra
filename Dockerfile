FROM golang:latest as builder
WORKDIR /src/lyra
RUN pwd
RUN apt-get update
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt-get install -y nodejs
# download and maximise caching go modules
COPY go.mod .
COPY go.sum .
RUN GO111MODULE=on go mod download
COPY . .
RUN make docker-build
# Copy binaries over to a new container
FROM alpine
WORKDIR /src/lyra/
<<<<<<< HEAD
ENV PATH /src/lyra/build/bin:$PATH
COPY --from=builder /src/lyra/build/bin/lyra /src/lyra/build/bin/lyra
=======
ENV PATH /src/lyra/build:$PATH
RUN apk add ca-certificates
COPY --from=builder /src/lyra/build/lyra /src/lyra/build/lyra
>>>>>>> Use alpine instead of golang container for runtime
COPY --from=builder /src/lyra/build/goplugins /src/lyra/build/goplugins
COPY --from=builder /src/lyra/workflows /src/lyra/workflows
COPY --from=builder /src/lyra/examples /src/lyra/examples
COPY --from=builder /src/lyra/docs /src/lyra/docs
COPY --from=builder /src/lyra/types /src/lyra/types
COPY --from=builder /src/lyra/data.yaml /src/lyra
CMD lyra apply foobernetes
