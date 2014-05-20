all: build

install-deps:
	wget http://cgit.lighttpd.net/weighttp.git/snapshot/weighttp-master.tar.gz &&\
	tar xvf weighttp-master.tar.gz

build:
	cd weighttp-master &&\
	./waf configure &&\
	./waf build

start:

stop:

kill:

clean:
	rm -rf weighttp-master*
