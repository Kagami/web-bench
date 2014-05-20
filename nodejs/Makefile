all: build

install-deps:

build:

start:
	NODE_DEBUG=cluster node app.js

# TODO: Graceful shutdown using PID.
stop: kill

kill:
	-killall node
	sleep 5s
	-killall -9 node

clean:
