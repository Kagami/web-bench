all: build

install-deps:
	rebar get-deps

build:
	rebar compile

start:
	erl -pa ebin deps/*/ebin -s hello_world -noshell

# TODO: Graceful shutdown using PID.
stop: kill

kill:
	-killall beam.smp
	sleep 5s
	-killall -9 beamp.smp

clean:
	rm -rf deps ebin erl_crash.dump
