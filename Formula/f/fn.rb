class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://ghfast.top/https://github.com/fnproject/cli/archive/refs/tags/0.6.64.tar.gz"
  sha256 "5911d78aa8e45406f0453851161b0b4d73432f01fa165a8600296dc64852fb52"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f9862c98ef39597deceb7b9d0119eb9143337df64b29cf069b0f8a2f04b156b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f9862c98ef39597deceb7b9d0119eb9143337df64b29cf069b0f8a2f04b156b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f9862c98ef39597deceb7b9d0119eb9143337df64b29cf069b0f8a2f04b156b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f70e9bdc3a2f7169a385b4fbff2f769f1bb8f8e0f1c9b69b8a4cb68f2ab3ed0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "643d53c0935482930f6f529f20578a35688334c79ae74ba71ae35b0d93560eb7"
    sha256 cellar: :any,                 x86_64_linux:  "fdca5aff58cf0fd1bb043c32360b701f02b98eb61520d6b016f7d623d8be52da"
  end

  depends_on "go" => :build

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