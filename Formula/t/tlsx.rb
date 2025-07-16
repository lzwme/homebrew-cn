class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://ghfast.top/https://github.com/projectdiscovery/tlsx/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "0aefac187dfe49f1c30b52736915c81b5c1fa215bd76a2417fff9d3006acc98a"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c29373fe2ba4c44c3178666a20b73349d907320ba837a22dd2da355e5667dd93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fed350b33cac09ec4fc18bbd9297c627dbf0874c369b37729521e844a1e7061e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d24577463b54435632dbd5957eff82160c00ca4141e4fce3eb3798aec162d66"
    sha256 cellar: :any_skip_relocation, sonoma:        "1accac8de524a65392d52081552d5865f00055f2ec88fac7198f5f2ed1a58da3"
    sha256 cellar: :any_skip_relocation, ventura:       "d01b982b1d8d8254f2334c2f0aa1a52d6e63276c613037ee6a8cb339e32b5486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80cf98c7a3e327debe032d86cab507baef07a5d3af790cc7874adede8d4b1d74"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tlsx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tlsx -version 2>&1")
    system bin/"tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end