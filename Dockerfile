FROM golang AS builder

WORKDIR /app
COPY . .

ENV GOFLAGS="-buildvcs=false"
ENV CGO_ENABLED=0
RUN go build -o /usr/local/bin/load-reeve-env .

FROM alpine

RUN apk add openssh sshpass
COPY --chmod=755 --from=builder /usr/local/bin/load-reeve-env /usr/local/bin/
COPY --chmod=755 docker-entrypoint.sh /usr/local/bin/

# SSH_LOGIN_USER: SSH user
ENV SSH_LOGIN_USER=
# SSH_LOGIN_PASSWORD: SSH password
ENV SSH_LOGIN_PASSWORD=
# SSH_LOGIN_KEY: SSH private key file
ENV SSH_LOGIN_KEY=
# SSH_HOST: Host to connect to
ENV SSH_HOST=
# ENV_<name>: Variables to be forwarded to the remote host

ENTRYPOINT ["docker-entrypoint.sh"]
