class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://ghfast.top/https://github.com/fnproject/cli/archive/refs/tags/0.6.49.tar.gz"
  sha256 "7bf90fc24df407bd321facda46350f752d7f18fbcc15e4bcefaec28d5d782eda"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f6e4e0ab93c10789b869a12fcad406ba9663713a8a1ea97f6e2d30da04bf09a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f6e4e0ab93c10789b869a12fcad406ba9663713a8a1ea97f6e2d30da04bf09a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f6e4e0ab93c10789b869a12fcad406ba9663713a8a1ea97f6e2d30da04bf09a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3cc34dbfd559cf5d9ab99984a8e3576cb53a527948cef35ae0505016df46576"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9db23f5ec5fd8ec9ed4c5127202ef33f3399e447548c6c2074fa7f639e13f3b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbdd83eda96a541286fe70c1d094bcd652395d9046170f212b08e22cff28c7a7"
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