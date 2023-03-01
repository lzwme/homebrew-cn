class Tproxy < Formula
  desc "CLI tool to proxy and analyze TCP connections"
  homepage "https://github.com/kevwan/tproxy"
  url "https://ghproxy.com/https://github.com/kevwan/tproxy/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "cee450df352683a390da1cd9d9b5a331252508d3ebab784924171f57cd427ee1"
  license "MIT"
  head "https://github.com/kevwan/tproxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97cb7d1f266be8c900f5b8d6a830c30af6e708b6aaaea2b17259c39353372c4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "306531fd7fdfee7a433df21ca0fa942d36bb32ba8a574b3e21f88230138b7c62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96af0294453ef100f4f2b6814c091612d014edeaaefa1a2a39bd282ee5786339"
    sha256 cellar: :any_skip_relocation, ventura:        "2e68b937b6dc89f20e32d58dcf684f02665f81614c62e0dbffb2b28de72270fc"
    sha256 cellar: :any_skip_relocation, monterey:       "118959714d2dc878768bc4f6662905174dd147e740bee1f91fc3273bff856955"
    sha256 cellar: :any_skip_relocation, big_sur:        "08cfd515479ddb256266e6d732b8b1709d85710482f19b33ab49e02f0cc39965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d23a92a3d42ec236004dec1f9cf8d229fbe99537bcfac21fb243341c15da55c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "pty"
    port = free_port

    # proxy localhost:80 with delay of 100ms
    r, _, pid = PTY.spawn("#{bin}/tproxy -p #{port} -r localhost:80 -d 100ms")
    assert_match "Listening on 127.0.0.1:#{port}", r.readline
  ensure
    Process.kill("TERM", pid)
  end
end