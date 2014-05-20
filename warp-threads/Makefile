WORKERS=$(shell nproc)
EXEC=warp-threads

all: build

install-deps:
	cabal sandbox init
	cabal install warp

build:
	ghc \
		-no-user-package-db -package-db .cabal-sandbox/*-packages.conf.d \
		-threaded -O2 -o $(EXEC) \
		app.hs

start:
	./$(EXEC) +RTS -N$(WORKERS)

# TODO: Graceful shutdown using PID.
stop: kill

kill:
	-killall $(EXEC)
	sleep 5s
	-killall -9 $(EXEC)

clean:
	rm -rf *.o *.hi $(EXEC) cabal.sandbox.config .cabal-sandbox
