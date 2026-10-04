class Portless < Formula
  desc "Replace port numbers with stable, named local URLs for humans and agents"
  homepage "https://portless.sh"
  url "https://registry.npmjs.org/portless/-/portless-0.15.7.tgz"
  sha256 "8217c7f7576378191c324e6f1a2d39f31a9c787a34ef68372b6e68f956c9a8fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3c9edd46b7e327c8700f07c444096f035eb35a98453ec55437743536af3998f9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    proxy_port = free_port
    server = testpath/"server.js"
    expected_url = "http://myapp.localhost:#{proxy_port}"
    expected_body = "Brewed fresh"

    server.write <<~JS
      const http = require("http");
      const body = "#{expected_body}";

      http.createServer((_req, res) => {
        res.writeHead(200, { "Content-Type": "text/plain" });
        res.end(body);
      }).listen(Number(process.env.PORT), process.env.HOST);
    JS

    ENV["HOME"] = testpath
    ENV["PORTLESS_PORT"] = proxy_port.to_s
    ENV["PORTLESS_STATE_DIR"] = (testpath/".portless").to_s
    ENV["PORTLESS_HTTPS"] = "0"

    pid = spawn bin/"portless", "myapp", formula_opt_bin("node")/"node", server

    begin
      output = shell_output("curl --silent --fail --retry-connrefused --retry 5 #{expected_url}")
      assert_equal expected_body, output

      assert_match "Proxy stopped.", shell_output("#{bin}/portless proxy stop")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end