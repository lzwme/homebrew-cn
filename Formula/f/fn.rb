class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://ghfast.top/https://github.com/fnproject/cli/archive/refs/tags/0.6.66.tar.gz"
  sha256 "0cda5864146b7280b8c05f98590b3b5e2e025d19634094e2e445ed1d8326fb9c"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "264e101de29c9b14f601b091109bc865a7f40f93e0f7c23ffa85924a9c584775"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "264e101de29c9b14f601b091109bc865a7f40f93e0f7c23ffa85924a9c584775"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "264e101de29c9b14f601b091109bc865a7f40f93e0f7c23ffa85924a9c584775"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d5f6e84e4516d1e2ad7f0a364a5cc24a3bca9dc32ceb2719d63c9917b6e416a"
    sha256 cellar: :any,                 x86_64_linux:  "b0429b8e74ee4f4467f606d8679c0d136591758ff7308951031a11ba52e0cfe8"
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