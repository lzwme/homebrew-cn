class Dysk < Formula
  desc "Linux utility to get information on filesystems, like df but better"
  homepage "https://dystroy.org/dysk/"
  url "https://ghfast.top/https://github.com/Canop/dysk/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "7ac25f80eb4e35fccf60d7c783692595b75c82026e37321ebe749c5a080e740a"
  license "MIT"
  head "https://github.com/Canop/dysk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "71a84c15f5f51125639cc21ccb7520077a3631197dba3227a2ae99d6593a4090"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "49314228c5eb014dfb1f49d6f920e7b6181a612d470d6ef4d19cb763d9323404"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a06527744b2b1e66a4161bbb53392d4e197d6fbae7479046cba8b9de8fdc41a"
    sha256 cellar: :any,                 arm64_linux:       "1058b739d45cd4d4d04d6682bae92d2d88fe99a4a12d78cce0715f70bce4750b"
    sha256 cellar: :any,                 x86_64_linux:      "379e5d52b2ef45810092abbbf906273eef5ca2f40aff3237586787dab7fb250b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "filesystem", shell_output("#{bin}/dysk -s free-d")
    assert_match version.to_s, shell_output("#{bin}/dysk --version")
  end
end