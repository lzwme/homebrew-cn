class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://ghfast.top/https://github.com/fnproject/cli/archive/refs/tags/0.6.44.tar.gz"
  sha256 "c1221ec2db47d050d72184c9ae5fbf1673b963cb5d7dffacf922086faebcb99f"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff15bb25a06de2786d7f3fbd20ad5dbf6ffa1bd8627879540d2dd37fc8855c5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff15bb25a06de2786d7f3fbd20ad5dbf6ffa1bd8627879540d2dd37fc8855c5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff15bb25a06de2786d7f3fbd20ad5dbf6ffa1bd8627879540d2dd37fc8855c5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "64a155d89d901ffcc1e03e8cc1e2c438d2da7f13c7c6e66e03720be4f57552b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cebfa5f6d42372325d10aeefbd90ccd66448a945cf9068520df7bf6d4dfda2ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc45eb1291499cbd7eaa03ea4d9be9347a0625bc9ba23630ab38cc9024c2e521"
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