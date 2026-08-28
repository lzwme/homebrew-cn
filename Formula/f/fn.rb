class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://ghfast.top/https://github.com/fnproject/cli/archive/refs/tags/0.6.65.tar.gz"
  sha256 "75bbd9969c19c8cfa5b61ea037820e65402ef490845a1dc20a9011091a2f2541"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1110587f79567f2e504a31fc7655591b4f33dbba7f50e272adb2d8ea48bf95e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1110587f79567f2e504a31fc7655591b4f33dbba7f50e272adb2d8ea48bf95e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1110587f79567f2e504a31fc7655591b4f33dbba7f50e272adb2d8ea48bf95e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce843598f2bc37461caee8fc3f64de72a1aa967ec3e2e147609a71dbad8f0692"
    sha256 cellar: :any,                 x86_64_linux:  "125764ececa6a48206f092b21764a524b9dce2ef9a1c25480a0af5266bb9b59a"
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