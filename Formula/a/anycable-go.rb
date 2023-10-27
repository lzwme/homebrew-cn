class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://ghproxy.com/https://github.com/anycable/anycable-go/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "44db12dee2950bc4d5d9e2f2f70f14c70bc90eb3975a24f58a34540cedfe0d4d"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d6a370ba6d698fc71a921a3f78c10d8703c91ba7f2d237cbc803eea3cd360b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "033ffeb6a4004c2a85cb5ec577002197b6f6440fc0e57be65d0c077c3d292be6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d09c4a0b16dc3507bbf5fd023a88dcdd1f97e67abb26936790b881399154ab65"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb54a34eea3a5d7ab73766208b4a81ae6fb57a24c3ee4c5b3be29b9f5e8f7947"
    sha256 cellar: :any_skip_relocation, ventura:        "29195a84f0b8e123d4f9666eff8579fdf674dea53c72d3be8365f7b566a1f4ac"
    sha256 cellar: :any_skip_relocation, monterey:       "f65fcedb6c5a21708f16217a168f12a64b7e9fa80462f750625f3341a7d44c15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecec25dd742dd4ede3cfecc87f11e6ba7422620cc7d5831fd36d90a71c813126"
  end

  depends_on "go" => :build

  def install
    ldflags = %w[
      -s -w
    ]
    ldflags << if build.head?
      "-X github.com/anycable/anycable-go/utils.sha=#{version.commit}"
    else
      "-X github.com/anycable/anycable-go/utils.version=#{version}"
    end

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/anycable-go"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/anycable-go --port=#{port}"
    end
    sleep 1
    output = shell_output("curl -sI http://localhost:#{port}/health")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end