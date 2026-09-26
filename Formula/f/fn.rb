class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://ghfast.top/https://github.com/fnproject/cli/archive/refs/tags/0.6.70.tar.gz"
  sha256 "152d807a9d411490c3ca61cf5a8c36ea9d66965ab08973e10310b0594992eb73"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f1522fda034fbd8d8345cca114a1e799a6b078d9e97470fdeefee93887d3c719"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f1522fda034fbd8d8345cca114a1e799a6b078d9e97470fdeefee93887d3c719"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f1522fda034fbd8d8345cca114a1e799a6b078d9e97470fdeefee93887d3c719"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c392dc19d358bb7e91149b774e384c91ba4b6b83da1a7cdeb151815b4934bb41"
    sha256 cellar: :any,                 x86_64_linux:      "833855e725ce0f971bea4fd7d4f6b1c9d730378d41082a957c6c3f5bbf7e641a"
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