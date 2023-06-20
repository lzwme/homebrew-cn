class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.29.3.tar.gz"
  sha256 "3c6d185bf0ead92c20118a19f2db6133628925238e3d04bc253af3b71dc3f66a"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1ce8d84fcbf9b1ec4ee3957fd14e30ab9603af16540a43974f249eb6a80b9e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61b040617587f63c2c605ce3045b99993f84f877c2d561b955d436caabfbf4eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a91342c24dab7b1d2e04a84d4160b65f8afbe29c283e1a23204bda51c3195b2"
    sha256 cellar: :any_skip_relocation, ventura:        "03997e4ca18fd7bbe2fe770da718467359bee55f60955863084e6635a1c818cf"
    sha256 cellar: :any_skip_relocation, monterey:       "a02bd430df0d493360ce1aa5748b9534ba2b57f85e9acce6f92566804c33e094"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f4a08a25486278e36f3d39ea24e67760f8343a932a1e2e8f7a2b3fd69daa0e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4343bcd607e9a09e91a82af4f405e5c143169b482b78d338d1ae72ba61e6e68b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end