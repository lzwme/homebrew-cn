class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://ghproxy.com/https://github.com/ordinals/ord/archive/refs/tags/0.8.1.tar.gz"
  sha256 "4f025958b0ed214ecf33c6f2c074d762ff20b6fef07e65d2a3908a1f95c5cf39"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a49f924b482232fe89296e7b2e90322b3f8a4727658370bb08153f2f207b9dd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce54f1e3f1cdc8f54eaae8d53c3d99d7d0b0684f980911e3074a90d2f195fcf7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e30f7b8cdc77805e8eaf02a8937519c2c6fd1f0f15d9c6567adfc4ca1144e0f"
    sha256 cellar: :any_skip_relocation, ventura:        "e68d6de6da4c4ab80e343a0e24a36a31acf594ffeb6945b4decd10d5c37d6eea"
    sha256 cellar: :any_skip_relocation, monterey:       "515dcffdb9b83eed47caa36d2aa5d88761912e5391cd32f237127f5d099d9282"
    sha256 cellar: :any_skip_relocation, big_sur:        "69bdf5c01897293e565d4fcf66ad661d26c20ee47697ec9c81b2f8ae88c6f710"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7539d6f7d9f978b3750f1dd551e34c1bc0e18f1906f72e2112bd51dfb0929d6a"
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