import BaseHTTPServer
import sys
class RequestHandler(BaseHTTPServer.BaseHTTPRequestHandler):
		
	def log_message(self, format, *args):
		pass
		
	def save_tokens(self):
		if "credentials" in self.path:
			urlpart = self.path.split("?")[1]
			params  = urlpart.split("&")
			url_params = dict([pair.split("=") for pair in params])
			
			if 'code' in url_params:
				code = url_params['code']
				self.code = code
				print self.code	
			
			#http://localhost:8118/credentials?code=<lots of chars>&state=<more chars>
	
	def do_GET(self):
		self.send_response(200)
		self.send_header("Content-type,","text/html")
		self.end_headers()
		self.code = None
		self.save_tokens()
		if self.code:
			self.wfile.write("<html>")
			self.wfile.write("<head>")
			self.wfile.write("<script>window.close();</script>")
			self.wfile.write("</head>")
			self.wfile.write("<body>You can close this page now.</body>")
			self.wfile.write("</html>")
			self.server.server_close()
			return
		else:
			self.write("<html></html>")



server_address = ('', 8118)
httpd = BaseHTTPServer.HTTPServer(server_address,RequestHandler)

try:
	while True:
		httpd.handle_request()
except:
	pass