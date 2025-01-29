# Base image for building
FROM golang:1.23.5 AS builder

# Set the working directory inside the container
WORKDIR /go/src/github.com/kubernetes-sigs/external-dns

# Copy source code and download dependencies
COPY . .
RUN go build

# Base image for the final runtime
FROM gcr.io/distroless/static:nonroot

# Set working directory and copy built binary from the builder stage
WORKDIR /
COPY --from=builder /go/src/github.com/kubernetes-sigs/external-dns/external-dns .

# Use a non-root user
USER nonroot:nonroot

# Command to run the binary
ENTRYPOINT ["/external-dns"]