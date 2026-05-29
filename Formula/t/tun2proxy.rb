class Tun2proxy < Formula
  desc "Tunnel (TUN) interface for SOCKS and HTTP proxies"
  homepage "https://github.com/tun2proxy/tun2proxy"
  url "https://ghfast.top/https://github.com/tun2proxy/tun2proxy/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "2df576b413978bff6294ea13e4c5f31485bb5c95d82a213a5a706032dfc451c6"
  license "MIT"
  head "https://github.com/tun2proxy/tun2proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bcfbfc5097d7d549b1aef23885651d97442636b2fdc3b1ae09706b0737585d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20d6d1c197da67b46b151b0e4b6b93537e1e8831da7774cb2d4ee690f9cf038f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b79894e5ffdf754e1488bf88ec9410d02c2aebaec5ac71715aeda9d54054bca7"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf86baa54edd1c470dc577a570b5d2277dc235e3d4b6cd929cac877a973031a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e06c6e1e780a1c9dda892263f35e3f3f17eaa981ce5819ef450e1635a3b675bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74af4877f7cf83a75cb10bc565bc247c42f8d157038b667b23b6bdddb6041dfe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tun2proxy-bin --version")

    expected = if OS.mac?
      "Operation not permitted (os error 1)"
    else
      "No such file or directory (os error 2)"
    end

    assert_match expected, shell_output("#{bin}/tun2proxy-bin --proxy socks5://127.0.0.1:1080 --tun utun4 2>&1", 1)
  end
end