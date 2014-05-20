SUBDIRS=$(dir $(wildcard */Makefile))
TARGETS=install-deps build clean start stop kill
SUBDIRS_TARGETS=$(foreach t,$(TARGETS),$(addsuffix $t,$(SUBDIRS)))
BENCH_SUBDIRS=$(sort $(dir $(wildcard */app*)))
BENCH_TARGETS=$(addsuffix bench,$(BENCH_SUBDIRS))

WEIGHTTP=weighttp/weighttp-master/build/default/weighttp
URL=http://127.0.0.1:8000/
LOGS=logs

all: build

check:
	@./check.pl

$(TARGETS): % : $(addsuffix %,$(SUBDIRS))

$(SUBDIRS_TARGETS):
	$(MAKE) -C $(@D) $(@F)

bench: $(BENCH_TARGETS)

$(BENCH_TARGETS):
	mkdir -p $(LOGS)
	###
	# Starting in background.
	###
	$(MAKE) -C $(@D) start &
	sleep 5s
	###
	# Warming up.
	###
	$(WEIGHTTP) -n 100000 -c 100 -t 10 -k $(URL)
	###
	# Doing bench (be patient).
	###
	stdbuf -oL -eL $(WEIGHTTP) -n 1000000 -c 1000 -t 10 -k $(URL) |& tee $(LOGS)/$(@D).log
	###
	# Stopping background app.
	###
	$(MAKE) -C $(@D) stop
	###
	# Sleeping before next bench.
	# All TIME_WAIT sockets should be closed.
	###
	sleep 60s
