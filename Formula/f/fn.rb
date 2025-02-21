class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https:fnproject.io"
  url "https:github.comfnprojectcliarchiverefstags0.6.39.tar.gz"
  sha256 "9816f20274b3b7fd7fc525547cfcef98be5f5b54aea7f8c615fc3e866c69432b"
  license "Apache-2.0"
  head "https:github.comfnprojectcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d3ac9f539dc3b3c2337740978c67341706c2a66893a0def856f978229fff8ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d3ac9f539dc3b3c2337740978c67341706c2a66893a0def856f978229fff8ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d3ac9f539dc3b3c2337740978c67341706c2a66893a0def856f978229fff8ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b94e12a4303dcef889d24188b2eede49c7f6ed365c832fbd7a186092b538670"
    sha256 cellar: :any_skip_relocation, ventura:       "5b94e12a4303dcef889d24188b2eede49c7f6ed365c832fbd7a186092b538670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a468637c283d8cf347bcc5775554be96d3bd377284af058d7e27d63865e7506"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}fn --version")
    system bin"fn", "init", "--runtime", "go", "--name", "myfunc"
    assert_path_exists testpath"func.go", "expected file func.go doesn't exist"
    assert_path_exists testpath"func.yaml", "expected file func.yaml doesn't exist"
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
        socket.print "HTTP1.1 200 OK\r\n" \
                     "Content-Length: #{response.bytesize}\r\n" \
                     "Connection: close\r\n"
        socket.print "\r\n"
        socket.print response
        socket.close
      end
    end
    sleep 1
    begin
      ENV["FN_API_URL"] = "http:localhost:#{port}"
      ENV["FN_REGISTRY"] = "fnproject"
      expected = "Successfully created app:  myapp"
      output = shell_output("#{bin}fn create app myapp")
      assert_match expected, output.chomp
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end