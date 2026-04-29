class Portless < Formula
  desc "Replace port numbers with stable, named local URLs for humans and agents"
  homepage "https://port1355.dev"
  url "https://registry.npmjs.org/portless/-/portless-0.11.0.tgz"
  sha256 "5ef55d1807acc914b9c49d78b20d11b14671fa52970cb2b9d7076fb2587f773f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0428822be7f067c6a2557d37476a16b3dc83d2853a04bb4e27a87d29bfd5c47d"
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

    pid = spawn bin/"portless", "myapp", Formula["node"].opt_bin/"node", server

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