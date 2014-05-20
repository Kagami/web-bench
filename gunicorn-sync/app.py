data = ['Hello, World!']
response_headers = [
    ('Content-type', 'text/plain'),
    ('Content-Length', str(len(data[0])))
]


def app(environ, start_response):
    start_response('200 OK', response_headers)
    return data
