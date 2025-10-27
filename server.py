import http.server
import socketserver
import os
import re

PORT = int(os.environ.get('PORT', 8000))

class MyHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        # Remove leading slash and any trailing slashes
        path = self.path.strip('/')

        # Check if this is a shader route (e.g., /ocean, /clouds, etc.)
        if path and not '.' in path and not '/' in path:
            # Check if this shader file exists
            shader_path = f'shaders/{path}.glsl'
            if os.path.exists(shader_path):
                # Read shader.html template
                try:
                    with open('shader.html', 'r') as f:
                        html_content = f.read()

                    # Replace the CURRENT_SHADER constant with the requested shader
                    modified_html = re.sub(
                        r"const CURRENT_SHADER = '[^']*';",
                        f"const CURRENT_SHADER = '{path}';",
                        html_content
                    )

                    # Send the modified HTML
                    self.send_response(200)
                    self.send_header('Content-type', 'text/html')
                    self.end_headers()
                    self.wfile.write(modified_html.encode())
                    return
                except Exception as e:
                    print(f"Error serving shader {path}: {e}")

        # Default behavior for all other requests
        super().do_GET()

    def end_headers(self):
        self.send_header('Cache-Control', 'no-store, no-cache, must-revalidate')
        super().end_headers()

Handler = MyHTTPRequestHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Server running at port {PORT}")
    print(f"Visit http://localhost:{PORT}/ for random shader")
    print(f"Visit http://localhost:{PORT}/ocean (or any shader name) for specific shader")
    httpd.serve_forever()
