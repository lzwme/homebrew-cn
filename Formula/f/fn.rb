class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://ghfast.top/https://github.com/fnproject/cli/archive/refs/tags/0.6.55.tar.gz"
  sha256 "76bb69d4d004f8465f13bd4abe50f22afed8205c6fa675d411b583448440df12"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41c96513f6aa197b0262d599c06b89b776d4698f8e4703fa5a0cb891dc893568"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41c96513f6aa197b0262d599c06b89b776d4698f8e4703fa5a0cb891dc893568"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41c96513f6aa197b0262d599c06b89b776d4698f8e4703fa5a0cb891dc893568"
    sha256 cellar: :any_skip_relocation, sonoma:        "d694ec43dd5b01c299c963ebefa8446ca395e793d4e4b77d2b8d4e969e2390cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd25f95de70a62be5735ca74ec68334511ffba1b677a4aad4c942dab0235241b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7050a5b448daa3be4c2d17193934864a197d67ec9ea3287d6d0217ec034d5e0"
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