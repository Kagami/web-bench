# Web benchmarks

Simple "hello world" benchmarks for some web servers and frameworks.
Done with high influence of TechEmpower's
[FrameworkBenchmarks](https://github.com/TechEmpower/FrameworkBenchmarks)
and some others, see [Links](#links).

## Test methodology

Each web server/framework was configured to gain maximum RPS on the test
stand (see below). For example disabled kernel-poll in Erlang gives
several KRPS. Your mileage may vary.

Configurations with huge performance difference has their own benchmarks
(e.g. `warp-threads` and `warp-processes`).

## Benchmarking

### Prepare

Compile and install required dependencies with:

```bash
$ make install-deps
```

You could run this and other steps only for single directory, for example:

```bash
$ make gunicorn-sync/install-deps
```

### Compile benchmarks

```bash
$ make
```

### Tune system (Linux)

Check your ulimit and sysctl settings with:

```bash
$ make check
```

See aditional info about system tuning in [Links](#links) section.

### Run benchmarks

```bash
$ make bench
```

Results will be available inside the `logs` directory.

## Links

**Similar benchmarks:**  
http://www.techempower.com/benchmarks/  
https://github.com/TechEmpower/FrameworkBenchmarks  
https://github.com/methane/echoserver  
http://www.yesodweb.com/blog/2011/03/preliminary-warp-cross-language-benchmarks

**System tuning:**  
http://gwan.com/en_apachebench_httperf.html  
http://selectnull.leongkui.me/2013/06/27/be-careful-with-tcp_tw_recycle/  
http://www.fromdual.com/huge-amount-of-time-wait-connections

**Tools:**  
https://github.com/lighttpd/weighttp (uses epoll and threads, nice utility)  
http://www.hpl.hp.com/research/linux/httperf/  
https://httpd.apache.org/docs/2.2/programs/ab.html (don't bench for >50K RPS, it will simply overload single CPU core)

**Other:**  
http://aosabook.org/en/posa/warp.html  
http://haskell.cs.yale.edu/wp-content/uploads/2013/08/hask035-voellmy.pdf  
http://mervine.net/performance-testing-with-httperf  
https://www.mnot.net/blog/2011/05/18/http_benchmark_rules (Benchmarks from this repo misses half of the rules… Well, it can't be helped.)  
http://www.cse.wustl.edu/ANCS/2007/slides/Bryan%20Veal%20ANCS%20Presentation.pdf

## Results

To get the most honest results you really should prepare and run all
these benchmarks by yourself. And tune some of them if necessary.

For example while doing my own behchmarks I discover some strange "bugs"
in others:
* Warp's performance in
  [Round 9](http://www.techempower.com/benchmarks/#section=data-r9&hw=peak&test=json)
  of TechEmpower's benchmarks seems weird: it even slower than Python!
* NodeJS in Snoyman's
  [bench](http://www.yesodweb.com/blog/2011/03/preliminary-warp-cross-language-benchmarks)
  shouldn't be that slow: after some investigations you will find that
  node have been running only on single CPU core

So you should never believe numbers from the net and check everything by
yourself. Don't believe mine as well. But for curious one and as a memo
I've recorded them anyway.

**Test stand:**
* Gentoo x86-64 (all software was built from sources with appropriate GCC flags)
* Linux 3.13
* Intel i7 3820 3.6 GHz (4 physical cores, 8 virtual cores with HT)
* 32GB RAM
* weighttp -c 1000 -t 10 -k
* Web server and test clients at the same host, connected via loopback

**Platform versions:**
* Python 2.7.5
* NodeJS 0.10.26
* GHC 7.8.2
* Erlang 17.0 (+hipe +kpoll +smp)
* Go 1.2

**Software versions:**
* Latest available in git master or in standart language's package manager
at the moment of testing

Check `logs` directory for resulting logs.
