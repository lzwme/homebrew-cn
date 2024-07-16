class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https:github.comhashicorpterraform-ls"
  url "https:github.comhashicorpterraform-lsarchiverefstagsv0.34.0.tar.gz"
  sha256 "0829c9aae26c2205ddb47193ddd3931423ca9b4fc62dee0bb18c47ad2e776f61"
  license "MPL-2.0"
  head "https:github.comhashicorpterraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f4f07904799adc62ae3f49a3345309a9d861e1cda4faf634c0fc3748e368d45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3cc33ea927a970aad671e539ff1f04afae78cb45a6f5521eb3b2b3efa526363"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c90a3664d77247f9045f8d4d1f9e88b90f344362964190154ac3dc2167dcf75"
    sha256 cellar: :any_skip_relocation, sonoma:         "6fedef049b911fa3c53c7fffbe60f53ff1a2759452e86c2df4d6480899587b80"
    sha256 cellar: :any_skip_relocation, ventura:        "cfa69062db12a05593c2dcd82b99edcc4b9ac792e8890d2985db5e60b2e1e330"
    sha256 cellar: :any_skip_relocation, monterey:       "96ce1aa9cd3331fc136d90230074fef8d0573eb00930dc0f0d7f17a350dd272c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2687a84c66a6751d371931b631a2a17a9a825ddab1193225c3fe3c6cd047c0f1"
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