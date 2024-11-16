class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https:github.comhashicorpterraform-ls"
  url "https:github.comhashicorpterraform-lsarchiverefstagsv0.36.0.tar.gz"
  sha256 "c69ff794cc0459188ebfc118d27344ec9683557000cf67857dc50ca819b9420e"
  license "MPL-2.0"
  head "https:github.comhashicorpterraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c99f5d8b34e868bfcdc425e718a493bdb7ca5ac67b6b753cd5633428c8fe15f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c99f5d8b34e868bfcdc425e718a493bdb7ca5ac67b6b753cd5633428c8fe15f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c99f5d8b34e868bfcdc425e718a493bdb7ca5ac67b6b753cd5633428c8fe15f"
    sha256 cellar: :any_skip_relocation, sonoma:        "def85ad807bf8a17c39a052a8a12494afb7f97d9c0f7e1b7b9279cc592fb83b9"
    sha256 cellar: :any_skip_relocation, ventura:       "def85ad807bf8a17c39a052a8a12494afb7f97d9c0f7e1b7b9279cc592fb83b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3980a66778d92171c24f1b5455fc4574cf39610548d732c5dd0e2602d61a268"
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