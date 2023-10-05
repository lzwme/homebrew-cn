class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://ghproxy.com/https://github.com/hashicorp/terraform-ls/archive/v0.32.0.tar.gz"
  sha256 "b1a03e072fa6d2d4471f07ed7073674be5ef773d0d8382272d8e36f477171568"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "efe34cc8f97229e06f7fc4368274037013ee5a06962b2e6502539dafa4762efc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62e23cfcbd6ec2ef3f7e43193260bdb77b036ef9c8cceb123b66b6476d3967c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d484168f35f43f91e9e1def4d68fe8d715a69b60a9dd1fade8ea2b5d3f9fd161"
    sha256 cellar: :any_skip_relocation, sonoma:         "b70650b8b92f5b02f4c6dc494a4da374f6908a477c39477e5933caca901a54af"
    sha256 cellar: :any_skip_relocation, ventura:        "42b4dc272ed7000913dc499ae62df9b33f9715fda7510e277e9de94e3c5d17a5"
    sha256 cellar: :any_skip_relocation, monterey:       "a7ab7097c188b1828653cdcb12b4d5d5792ed2c43a59fa53be6d3b4c99d50f5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0db13af197d19fa021ff2e07ef9788ceef00ff73450f37c24974595b3f24be49"
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
      exec "#{bin}/terraform-ls serve -port #{port} /dev/null"
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