class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https:fnproject.io"
  url "https:github.comfnprojectcliarchiverefstags0.6.31.tar.gz"
  sha256 "4bc673fceba2b1f372889a9c66049b9705043cc775d1f626b30ac6cbb13ac024"
  license "Apache-2.0"
  head "https:github.comfnprojectcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "beb3ad37c1a9c92dc37bbe000755eff2631c3bb80067345e9bcc263d6470f99f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5509f3cbb1cbcd73ef3c71cea3201242a86cd8253199710a91998325eb5f73d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a929414621d4e68f844fb0740d1a6794a294289ebab6c827f690ba67eeddc218"
    sha256 cellar: :any_skip_relocation, sonoma:         "acf9194fb67bf0018dbdc670e422049e6373876d2c146614c6fb2e18534d5fea"
    sha256 cellar: :any_skip_relocation, ventura:        "76566d9c8c5671ee3e622b2bc0a6e5babddb045aa2fc81ba33f5e3bfe5c950c0"
    sha256 cellar: :any_skip_relocation, monterey:       "c5e432daf7f9a66db151e6f7264d5bf7ebf59fe62e29ca36f516d491c4956a4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a59bbf7f977a37ef855c7501e5e6ee14fe9e313f7231302b5f3c70627408d65d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}fn --version")
    system "#{bin}fn", "init", "--runtime", "go", "--name", "myfunc"
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