class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https:fnproject.io"
  url "https:github.comfnprojectcliarchiverefstags0.6.38.tar.gz"
  sha256 "de610147032702662b57028a383436c5923cf0f0e6332b1e5dcb96ceaa31b94b"
  license "Apache-2.0"
  head "https:github.comfnprojectcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ebbfb724ac53f90ad55600c24333e9a6287cde7e19097b81c8e343275c0e7a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ebbfb724ac53f90ad55600c24333e9a6287cde7e19097b81c8e343275c0e7a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ebbfb724ac53f90ad55600c24333e9a6287cde7e19097b81c8e343275c0e7a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "302c1ca22f7bebfcdca994397cf658fb99a36a3182e34bd40122c4acd1255090"
    sha256 cellar: :any_skip_relocation, ventura:       "302c1ca22f7bebfcdca994397cf658fb99a36a3182e34bd40122c4acd1255090"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d96af2e3101d7c78dbd05203c4351561acb84715b397936f8836af6430b82489"
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