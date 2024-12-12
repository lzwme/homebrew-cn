class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https:github.comhashicorpterraform-ls"
  url "https:github.comhashicorpterraform-lsarchiverefstagsv0.36.1.tar.gz"
  sha256 "342692d44a1be59e9b7845702b7329385503371614ce2da73058f0c646f1a886"
  license "MPL-2.0"
  head "https:github.comhashicorpterraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fafe071e04711c387b29143b18c2104945fd7d697540fdfd18e5d251bdfdf96a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fafe071e04711c387b29143b18c2104945fd7d697540fdfd18e5d251bdfdf96a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fafe071e04711c387b29143b18c2104945fd7d697540fdfd18e5d251bdfdf96a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2749a9c8f3587e76511946d11db6b5966a06f6364939125629011bcfe24e98f"
    sha256 cellar: :any_skip_relocation, ventura:       "a2749a9c8f3587e76511946d11db6b5966a06f6364939125629011bcfe24e98f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3ab8c3d0a3e3f3bba2fb0320c0e88b58820455105f9756c579fb3660baefaf5"
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