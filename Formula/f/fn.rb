class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://ghfast.top/https://github.com/fnproject/cli/archive/refs/tags/0.6.50.tar.gz"
  sha256 "f0fed3aa69c6c45c1aaf66b5d0ee3180d8b6d2cc88202fac3eac2c868a73f789"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fef52878492f26047f77979aae8269efe0e4bd4a643929444c9238857ad5450a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fef52878492f26047f77979aae8269efe0e4bd4a643929444c9238857ad5450a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fef52878492f26047f77979aae8269efe0e4bd4a643929444c9238857ad5450a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c84370e995b77d4484baf5b047ab96605bae8f8cd655f373fae9d4316c043b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5734b2f6e3678d369aa085d81fc8119820a1eae3c0c9d50a4572d822cc198c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "334693f3e66d898742bb2ab653afb043fe777d79da5414f909d680854c8ddba4"
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