class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https:fnproject.io"
  url "https:github.comfnprojectcliarchiverefstags0.6.35.tar.gz"
  sha256 "c912b2724f71c6681abc9ba3a96713ec2e208645c4225c83c309bfd8fa36af19"
  license "Apache-2.0"
  head "https:github.comfnprojectcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bc5f720d26e8e6c84ff69aba388ca7e75a450a387faad659bcb1a548caee897"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bc5f720d26e8e6c84ff69aba388ca7e75a450a387faad659bcb1a548caee897"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9bc5f720d26e8e6c84ff69aba388ca7e75a450a387faad659bcb1a548caee897"
    sha256 cellar: :any_skip_relocation, sonoma:        "df2b2e7a5093f61eff9948d63bcc1e4d5c6c684a393d4136a0da7fa54f14cec4"
    sha256 cellar: :any_skip_relocation, ventura:       "df2b2e7a5093f61eff9948d63bcc1e4d5c6c684a393d4136a0da7fa54f14cec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3ea8270eab69f518ab6aa5e4ac695f61068beccda445bcc108091fd89578c8d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}fn --version")
    system bin"fn", "init", "--runtime", "go", "--name", "myfunc"
    assert_predicate testpath"func.go", :exist?, "expected file func.go doesn't exist"
    assert_predicate testpath"func.yaml", :exist?, "expected file func.yaml doesn't exist"
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