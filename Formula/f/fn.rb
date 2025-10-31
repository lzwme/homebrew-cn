class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://ghfast.top/https://github.com/fnproject/cli/archive/refs/tags/0.6.45.tar.gz"
  sha256 "6c081f2fce1e2f69a7fd902cfe892441b1da5cb9034e51ea389b1be95b41918b"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3081dbaf859719c0fc25aec3b90b59351f19687b8e9e24f86a254d749560ff7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3081dbaf859719c0fc25aec3b90b59351f19687b8e9e24f86a254d749560ff7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3081dbaf859719c0fc25aec3b90b59351f19687b8e9e24f86a254d749560ff7"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfc3feadca05c2c284387662cf8692ac3a8d5d10d72a23e9b96aa672c7a55f8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91f3ee4eba678efc55676aa9206608f7e3d1f82c3b613f7f43a78be187f8e702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8530e24587df960ac65f508715ba98e569817f0ed77a5703eea75602fff5935"
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