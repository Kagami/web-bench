WORKERS=$(shell nproc)
PID=app.pid

all: build

install-deps:
	virtualenv .venv
	.venv/bin/pip install gunicorn meinheld

build:

start:
	.venv/bin/gunicorn \
		-w $(WORKERS) \
		-k meinheld.gmeinheld.MeinheldWorker \
		-b 127.0.0.1:8000 \
		-p $(PID) \
		app:app

stop:
	kill `cat $(PID)`
	sleep 5s

kill:
	-pkill gunicorn
	sleep 5s
	-pkill -9 gunicorn

clean:
	rm -rf *.pyc .venv $(PID)
