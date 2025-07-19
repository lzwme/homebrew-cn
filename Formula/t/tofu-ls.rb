class TofuLs < Formula
  desc "OpenTofu Language Server"
  homepage "https://github.com/opentofu/tofu-ls"
  url "https://ghfast.top/https://github.com/opentofu/tofu-ls/archive/refs/tags/v0.0.9.tar.gz"
  sha256 "b51402936314f4495a440a99eecedccc07c0175f81c9533eb3510f9e4f76d879"
  license "MPL-2.0"
  head "https://github.com/opentofu/tofu-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eeb813558e7c0b53839efb0be344b9bce8e704cb37dad5d161bd6cbe362611a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eeb813558e7c0b53839efb0be344b9bce8e704cb37dad5d161bd6cbe362611a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eeb813558e7c0b53839efb0be344b9bce8e704cb37dad5d161bd6cbe362611a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "2393223139ffd08bc902c9b42fc6f3a4d0a5d26fa87720cc8ab719bd9f659a92"
    sha256 cellar: :any_skip_relocation, ventura:       "2393223139ffd08bc902c9b42fc6f3a4d0a5d26fa87720cc8ab719bd9f659a92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11af98ca5b53dbbb4d4d3459def3b6d5a18a9c2ec84e8e813651e5b248eae808"
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
      exec "#{bin}/tofu-ls serve -port #{port} /dev/null"
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