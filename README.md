# Flex DNS

A simple flexible DNS server with REST API.

## Features

- Add, update, delete A Record through REST API.
- Fast DNS server

## Requirement

- Docker
- Docker Compose

## Usage

### Startup

```bash
> git clone https://github.com/HeRoMo/flex-dns.git
> cd flex-dns
> docker-compose build
> docker-compose up
```

### Add A Record and resolve address

```bash
> docker-compose up -d
> curl -X POST \
  http://localhost:4567/host \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -d 'name=hoge.sample.com&address=192.168.1.111'
{"result":"ok"}
> dig @localhost -p 2346 hoge.sample.com

; <<>> DiG 9.10.6 <<>> @localhost -p 2346 hoge.sample.com
; (2 servers found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 13705
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0
;; WARNING: recursion requested but not available

;; QUESTION SECTION:
;hoge.sample.com.               IN      A

;; ANSWER SECTION:
hoge.sample.com.        86400   IN      A       192.168.1.111

;; Query time: 4 msec
;; SERVER: ::1#2346(::1)
;; WHEN: Tue Mar 10 21:45:08 JST 2020
;; MSG SIZE  rcvd: 49
```

### REST API

#### POST /host

Add or update an A Record.

params:
  - `name` hostname
  - `address` IPv4 address

response:
  - `{"result": "ok"}` success
  - `{"result": "ng"}` fail

#### GET /list

Get all records.

#### DELETE /host

Delete an A Record.

## LICENSE

[MIT](LICENSE)
