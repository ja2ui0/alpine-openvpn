FROM alpine:edge

RUN apk add --no-cache --update openvpn && \
  touch /ovpn; touch /cred

COPY init /init

CMD ["/init"]
