class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https:fnproject.io"
  url "https:github.comfnprojectcliarchiverefstags0.6.40.tar.gz"
  sha256 "2110bc0336583533e16b36bcf3641dcd2e752b8de888f0f2e291832ec070ed24"
  license "Apache-2.0"
  head "https:github.comfnprojectcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2c1350bc80346182622f7d4f7712eec7f1e686e77e5d1b6158ed4af4acee387"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2c1350bc80346182622f7d4f7712eec7f1e686e77e5d1b6158ed4af4acee387"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2c1350bc80346182622f7d4f7712eec7f1e686e77e5d1b6158ed4af4acee387"
    sha256 cellar: :any_skip_relocation, sonoma:        "daea33116d7d178b549566d74f7eb7c7b90a359d6ca37a166fa936064a69d6e2"
    sha256 cellar: :any_skip_relocation, ventura:       "daea33116d7d178b549566d74f7eb7c7b90a359d6ca37a166fa936064a69d6e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d37b19657aa79c24a388bc6f181e316d9aa7b012e71111cbb5051fc51253e38e"
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