class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://ghfast.top/https://github.com/fnproject/cli/archive/refs/tags/0.6.58.tar.gz"
  sha256 "aa708e4d384fdf46e7feedc69c90ec4e021bcba0e48f9957c11e5575ef49d2fc"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5016319e6a0b2d5e92f6f95dba1d256a2207e5be4c002ce05eb18273a7e7bf98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5016319e6a0b2d5e92f6f95dba1d256a2207e5be4c002ce05eb18273a7e7bf98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5016319e6a0b2d5e92f6f95dba1d256a2207e5be4c002ce05eb18273a7e7bf98"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5c685272de8c589f03bcb688b76550376c5ab024990df7c85c6db6c7972ec98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f0d0c12c0cebdf8a067d37b9d5df2b20c9f034aafcfb6357dd78b2bf94e57c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cec8f8f3490f948c6e145453006253362f5cd51739a2a3d9a6525f2061abe421"
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