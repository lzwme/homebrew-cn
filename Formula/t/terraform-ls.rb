class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https:github.comhashicorpterraform-ls"
  url "https:github.comhashicorpterraform-lsarchiverefstagsv0.32.6.tar.gz"
  sha256 "9a7e5d0bbfabcadd653d7fbc326f8bc3c458aa4f4652c519e8fe4f3bd464a8a6"
  license "MPL-2.0"
  head "https:github.comhashicorpterraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2689b564da79c3493ec0f976ce99e22ebacf4056e56be291d102c3ce0345e01e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de9abe3ac255d0d86e4a8d714c5f39a5f0937bc9161034b582efb6dde38d938e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42a049b7187b959f1e6e670bb14a900754c28318df88571aefc23fc14f324f61"
    sha256 cellar: :any_skip_relocation, sonoma:         "f7b6d291a9f433fd368113457fab531866d3376010df493e606e81885c71bad5"
    sha256 cellar: :any_skip_relocation, ventura:        "1b3f8ea4e9c4a03b03b23496c68c891217c25f3fb61b9aaff0c61d4600dec008"
    sha256 cellar: :any_skip_relocation, monterey:       "6469ce4514b031d763a532e1125e48eeea01831db15b3728439f68ac3424cb6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f78dbe363a95f049502388fea25772dd4228ee9aef526a69b56b243013d2c1d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.rawVersion=#{version}+#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
  end

  test do
    port = free_port

    pid = fork do
      exec "#{bin}terraform-ls serve -port #{port} devnull"
    end
    sleep 2

    begin
      tcp_socket = TCPSocket.new("localhost", port)
      tcp_socket.puts <<~EOF
        Content-Length: 59

        {"jsonrpc":"2.0","method":"initialize","params":{},"id":1}
      EOF
      assert_match "Content-Type", tcp_socket.gets("\n")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end