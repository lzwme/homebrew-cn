class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://ghfast.top/https://github.com/fnproject/cli/archive/refs/tags/0.6.46.tar.gz"
  sha256 "9c7ae072cfb1eb4787f2026b08fc1605dc684a9184cdccbb5c87c26785540987"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d69b575c388e17f554f7dd1bad590988daba817593f1df520b55b4ec278adeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d69b575c388e17f554f7dd1bad590988daba817593f1df520b55b4ec278adeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d69b575c388e17f554f7dd1bad590988daba817593f1df520b55b4ec278adeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9a2359c7f46095fc74a0de9ea4b3e636b31150e540886c7d276ed6ec3ff47b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50b62f363757af4f2043ec4867a2aec0d44a4f2d2befcf89eaaa9d9911c52568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "465af66eb698f6c438fba7b132e9bfea5fa2cc21f7c04f6f3dd4a634fb752a45"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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