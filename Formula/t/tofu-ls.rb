class TofuLs < Formula
  desc "OpenTofu Language Server"
  homepage "https://github.com/opentofu/tofu-ls"
  url "https://ghfast.top/https://github.com/opentofu/tofu-ls/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "aac34c4a0c3b6e096f5255060bd07cf3c7b0e2f70f0d648fb8409102d279c04c"
  license "MPL-2.0"
  head "https://github.com/opentofu/tofu-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e364ecfb57edada0db9aa010296e6c5769dd557314a8f080367f11c076ea102"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e364ecfb57edada0db9aa010296e6c5769dd557314a8f080367f11c076ea102"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e364ecfb57edada0db9aa010296e6c5769dd557314a8f080367f11c076ea102"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e364ecfb57edada0db9aa010296e6c5769dd557314a8f080367f11c076ea102"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f8dc5ac9e766fa9bfcf738f4bd40124ebb78d01f35d53fabec37e9bfb811c50"
    sha256 cellar: :any_skip_relocation, ventura:       "7f8dc5ac9e766fa9bfcf738f4bd40124ebb78d01f35d53fabec37e9bfb811c50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70bb5b7a184adeba839cd352fdb47ffc67ca2715ff0cc5ae7a89ca0f3b04bb66"
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