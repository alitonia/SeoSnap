from rendertron_cache_server import server, log

log.init()
s = server.Server()
application = s.app

