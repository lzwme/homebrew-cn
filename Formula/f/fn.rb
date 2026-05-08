class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://ghfast.top/https://github.com/fnproject/cli/archive/refs/tags/0.6.52.tar.gz"
  sha256 "2721ea38ba546abb08a6f064cc78fef3b02f3672b78594b899ff68c86dd47234"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79d9cf7fc649fb4ea6e3eb45a3773e098c774109e1a68c6c87ae4870b10d1113"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79d9cf7fc649fb4ea6e3eb45a3773e098c774109e1a68c6c87ae4870b10d1113"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79d9cf7fc649fb4ea6e3eb45a3773e098c774109e1a68c6c87ae4870b10d1113"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2c023709edd5d39fa8c672b959716411ff78becce63a15ceb28b2c8a0e22b2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d01b5cbe8e2523c3c852d77aaecbd9af75a84e19564de1767b8c308fd80539b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a79d11e532fab00be589dfa73b1b0bd21fb0ab2a85282c7adf5c46dfbeef47f9"
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