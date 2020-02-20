# alpine-openvpn
Minimal openvpn client container image built on Alpine.

## Purpose
The intention of this container image is to allow other containers to use its network stack with the `--net=container:<name>` argument in a `docker run` command, or similar.

This is one way to run multiple VPNs servicing multiple endpoints on a single docker host.

## Usage
Here is an example script you could use to run this image.

```
#!/bin/bash
#set -x

dowork() {
  docker run \
    -d \
    --rm \
    --name <name> \
    --hostname <hostname> \
    -p <src>:<dst> \
    --cap-add=NET_ADMIN \
    --device=/dev/net/tun \
    -v ${PWD}/ovpn:/ovpn \
    -v ${PWD}/cred:/cred \
    ja2ui0/openvpn:latest
}

main() {
  if [[ -f ${PWD}/cred ]]; then
    dowork
  else
    read -p "Username: " user
    read -p "Password: " pass
    echo "${user}" > ${PWD}/cred
    echo "${pass}" >> ${PWD}/cred
    dowork
    rm cred
  fi
}

main "$@"
```

When customizing this script for your own VPN container, be sure to edit `--name`, `--hostname`, and all `-p` (ports).

Also, be sure your `./cred` (if supplied) and `./ovpn` files are appropriate.
- `./cred` files are simply a username and password on separate lines.
- If you don't supply `./cred`, you'll be prompted. This allows manual connections to VPNs with 2FA.
- `./ovpn` file must have the certificates / keys embedded, if required.
