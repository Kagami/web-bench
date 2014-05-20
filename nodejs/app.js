var cluster = require('cluster');
var http = require('http');
var numCPUs = require('os').cpus().length;
var body = 'Hello, World!';
var headers = {
  'Content-Type': 'text/plain',
  'Content-Length': body.length.toString(),
};

if (cluster.isMaster) {
  // Fork workers.
  for (var i = 0; i < numCPUs; i++) {
    cluster.fork();
  }

  cluster.on('exit', function(worker, code, signal) {
    console.log('worker ' + worker.process.pid + ' died');
  });
} else {
  // Workers can share any TCP connection
  // In this case its a HTTP server
  http.createServer(function(req, res) {
    res.writeHead(200, headers);
    res.end(body);
  }).listen(8000);
}
