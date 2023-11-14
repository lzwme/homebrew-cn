class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://ghproxy.com/https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "7314e3dc86464daa68e0276676703199214b08c789392e24367a9fc014122d3f"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f83299a663235deffa7ecbc75842804da1765b49ef4f9d42a676ccf758d6b73"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "502c14c7735ee10570a76280a0df8fb8806616427d42c090e53414c1c43a93fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0bac73371e897f54b466a56093ca936bc1592b9ff137774b01a5630f6a9e628"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5c5cf5d21f811d9ab041da29f9d8f92cf24ab6f7e61d365685975ca6325ffa6"
    sha256 cellar: :any_skip_relocation, ventura:        "2400f8d5d0a6320d4677cf0228ddc4ad7cc604e823b0c75c274642d150a29ece"
    sha256 cellar: :any_skip_relocation, monterey:       "e061c0d8eabf7f2b114a3c2129420c24a394620d20a4c3764115345d2bbaf2b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e2d8f61740cfb6b9ba2f487b55f9f4a2333e84ce0dcdfa49da12f628302e4a7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    port = free_port

    pid = fork do
      exec "#{bin}/pmtiles", "serve", ".", "--port", port.to_s
    end
    sleep 3
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "404 Not Found", output
  ensure
    Process.kill("HUP", pid)
  end
end