class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://ghproxy.com/https://github.com/ordinals/ord/archive/refs/tags/0.10.0.tar.gz"
  sha256 "310fdb6ee3d6227942249419483851035707094d90c2dea60ac3a852df948a51"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "164772856cedf80101ad38876c6564878eeff18cb0076356963d3178addace92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a337dae5b96d04bf352169d2a1ec09431561cd5e63894af30f699d76194a0a3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4251d1f5ce35b50196b4d79589b5a7a4fd0e37adae103fa31ab7cd6a8cc21c00"
    sha256 cellar: :any_skip_relocation, sonoma:         "680c44b8e750872fc356d662346566fbba41ee76d5f7a708e613d8b68aaab57f"
    sha256 cellar: :any_skip_relocation, ventura:        "cfcac88176d7bcaf2f8a42ea48a46975a04caa15b4d71889776273351fe5acfc"
    sha256 cellar: :any_skip_relocation, monterey:       "4bdf246a1f2858c3c05dc216355a3952b19fddacc5662ee89de1f10b04527be2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d4f0ac5968afb2ee9bfba871c50bf2ffa854a78f7fb146cbf44ae6ebfb49561"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected = "error: failed to connect to Bitcoin Core RPC at 127.0.0.1:8332/wallet/ord"
    assert_match expected, shell_output("#{bin}/ord info 2>&1", 1)

    expected = "error: failed to spawn `bitcoind`"
    assert_match expected, shell_output("#{bin}/ord preview 2>&1", 1)

    assert_match "ord #{version}", shell_output("#{bin}/ord --version")
  end
end