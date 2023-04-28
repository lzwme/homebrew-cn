class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://ghproxy.com/https://github.com/hashicorp/terraform-ls/archive/v0.31.1.tar.gz"
  sha256 "dfd21edfdc315a0abfa381d56b5fc29fea19be61debf23c2d6370094191a67d7"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3997a7f4117936e68e97cfcefc1419d3f9797d887959431cd7cfc953f9975424"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3997a7f4117936e68e97cfcefc1419d3f9797d887959431cd7cfc953f9975424"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3997a7f4117936e68e97cfcefc1419d3f9797d887959431cd7cfc953f9975424"
    sha256 cellar: :any_skip_relocation, ventura:        "8008144db461881e4547c5f07488fe711b4219be22cbe16966075912ae374585"
    sha256 cellar: :any_skip_relocation, monterey:       "8008144db461881e4547c5f07488fe711b4219be22cbe16966075912ae374585"
    sha256 cellar: :any_skip_relocation, big_sur:        "8008144db461881e4547c5f07488fe711b4219be22cbe16966075912ae374585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25d0e4f4bf5f1a97d21f643ddde4fcb1cd956eb124a01506ed82aa5751e7a2f6"
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