class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://ghfast.top/https://github.com/fnproject/cli/archive/refs/tags/0.6.71.tar.gz"
  sha256 "766066f247a133b7204750409779fcf4f5f8782dbba1ff1c29300e3e84f9a1c6"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e139a02d322e7f33d397d3483b67dd13e28221a0681b7bd5eb9ebaf7cea34012"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e139a02d322e7f33d397d3483b67dd13e28221a0681b7bd5eb9ebaf7cea34012"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e139a02d322e7f33d397d3483b67dd13e28221a0681b7bd5eb9ebaf7cea34012"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cd43fcc60e442b83139cd199dee40e04995514688cfe1c9f4ff8b2fcb2874a2e"
    sha256 cellar: :any,                 x86_64_linux:      "d4da5f307fc52ad2863171be1391fd493d293b7420d6e5e6fd13709a30b96e03"
  end

  depends_on "go" => [:build, :test]

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fn --version")
    system bin/"fn", "init", "--runtime", "go", "--name", "myfunc"
    assert_path_exists testpath/"func.go", "expected file func.go doesn't exist"
    assert_path_exists testpath/"func.yaml", "expected file func.yaml doesn't exist"
    port = free_port
    server = TCPServer.new("localhost", port)
    pid = fork do
      loop do
        response = {
          id:         "01CQNY9PADNG8G00GZJ000000A",
          name:       "myapp",
          created_at: "2018-09-18T08:56:08.269Z",
          updated_at: "2018-09-18T08:56:08.269Z",
        }.to_json

        socket = server.accept
        socket.gets
        socket.print "HTTP/1.1 200 OK\r\n" \
                     "Content-Length: #{response.bytesize}\r\n" \
                     "Connection: close\r\n"
        socket.print "\r\n"
        socket.print response
        socket.close
      end
    end
    sleep 1
    begin
      ENV["FN_API_URL"] = "http://localhost:#{port}"
      ENV["FN_REGISTRY"] = "fnproject"
      expected = "Successfully created app:  myapp"
      output = shell_output("#{bin}/fn create app myapp")
      assert_match expected, output.chomp
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end