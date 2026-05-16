class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://ghfast.top/https://github.com/fnproject/cli/archive/refs/tags/0.6.57.tar.gz"
  sha256 "3f78f0a3a8efe59105f71ee8297b17bf55bd0c38cb721fe52945168599b35a1c"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd53c67a42b46a5a5615f9d1ea60e964d28f1ceaf88390f1e6217bf9e330b22b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd53c67a42b46a5a5615f9d1ea60e964d28f1ceaf88390f1e6217bf9e330b22b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd53c67a42b46a5a5615f9d1ea60e964d28f1ceaf88390f1e6217bf9e330b22b"
    sha256 cellar: :any_skip_relocation, sonoma:        "baa30f1ebe1b06829576d731c045f339be7ff190d5a56667641f40332ce1146e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "103b563741ef683258abffeaff0f80428fe48d32cf42262bca61358fb52504c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a48c470e2f9a78787c7983184672a4d1d9597c25e0d7da9d6b07b5f2c4ffba7"
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