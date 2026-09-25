class GrinWallet < Formula
  desc "Official wallet for the cryptocurrency Grin"
  homepage "https://grin.mw"
  url "https://ghfast.top/https://github.com/mimblewimble/grin-wallet/archive/refs/tags/v5.5.0.tar.gz"
  sha256 "faa8deebb693cd43d62f4c4c5c598294f7a136929d8dcea1c187656342cae01d"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4ed02d4fbaec1df37883d93751d45ec6b287e959a62075e9757e28dc60cbd970"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d96c21b3a5460e1f0408a2047b1fc484e4074daf9de5776484395ebedab2d8e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d63c9f8a494c6f4087c1a4612ae14fde97a1f8d89126d1ba1978324201b5912d"
    sha256 cellar: :any,                 arm64_linux:       "839f63ee589971f0b35131de3edb60df0fa5319e426d8b2d9065b29df3e82866"
    sha256 cellar: :any,                 x86_64_linux:      "bf6d8f17048485bc3a7732258956cd3d77d4daa917c1c4ed061db98b7e155cc7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "openssl@4" # Uses Secure Transport on macOS
  end

  resource "grin" do
    url "https://ghfast.top/https://github.com/mimblewimble/grin/archive/refs/tags/v5.5.1.tar.gz"
    sha256 "841a698986ff05768c6d7cdf2e59d44571533522fbcffdab0a0de01c8de1d4a3"
  end

  deny_network_access!

  def fetch
    resource("grin").stage buildpath/"grin"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "yes | #{bin}/grin-wallet init"
    assert_path_exists testpath/".grin/main/wallet_data/wallet.seed"
  end
end