EXEC=go-app

all: build

install-deps:

build:
	go build -o $(EXEC)

start:
	./$(EXEC)

# TODO: Graceful shutdown using PID.
stop: kill

kill:
	-killall $(EXEC)
	sleep 5s
	-killall -9 $(EXEC)

clean:
	rm -rf $(EXEC)
