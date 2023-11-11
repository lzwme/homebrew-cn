class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://ghproxy.com/https://github.com/fnproject/cli/archive/refs/tags/0.6.28.tar.gz"
  sha256 "15e300b06ff9555a8b4a32cc335d91b6165ef181fd0dd9bb098f47736647e17c"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6508fa0f0e0b6e2049862cb2438e30e4e14749854cadd423091628b5d4a199b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "921c7e0b7cfc679c11356d17e4e50798c9ccdc8d048022bb7d2d1585aa3e3722"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e5eabb4514ad0cc325d848b320ae6b774511bff248d9765128c3dfd41576bcc"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec7db21dabc499a70ef5d219c2ff120ae947dde51deeb8decb77f083a995d6c4"
    sha256 cellar: :any_skip_relocation, ventura:        "06ea2e0334026680c4ab4ace75bb746e24e895413c4b9999e014d5c89ca00e97"
    sha256 cellar: :any_skip_relocation, monterey:       "31c2cae0d6c0a577798d3fa1468d43be547fb6cd21df9e41d432f0e7e78a4ca5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10ab24ed2de954976ea90479c4e9651c30278df6b79215d4f7b01673bc425c49"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fn --version")
    system "#{bin}/fn", "init", "--runtime", "go", "--name", "myfunc"
    assert_predicate testpath/"func.go", :exist?, "expected file func.go doesn't exist"
    assert_predicate testpath/"func.yaml", :exist?, "expected file func.yaml doesn't exist"
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