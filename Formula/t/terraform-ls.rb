class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://ghfast.top/https://github.com/hashicorp/terraform-ls/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "cf9aadc9ccb5fa5f8a778a18e3c3961e5855acebac52fd5f3e59b5e934ac2c05"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d367e827b49a19d63ef1f0c4cc22df449be6fc86f16e8cc422c16aa485e37dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d367e827b49a19d63ef1f0c4cc22df449be6fc86f16e8cc422c16aa485e37dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d367e827b49a19d63ef1f0c4cc22df449be6fc86f16e8cc422c16aa485e37dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c7fd82ea0f58449594a774ae41675aade662bf9af21df4d1f26383e81f2bad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63c838b3d6d1bc36f258ee290bf2b651f046e705a23315d56c2719bab6149d10"
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