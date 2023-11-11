class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://ghproxy.com/https://github.com/ordinals/ord/archive/refs/tags/0.11.1.tar.gz"
  sha256 "a84d4a30d51595603d39db6d88ee5b764cc0459ee238716af1c5585a75037fb0"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41b0905028b255a87b527005b6865c01ee6db4242eb08b2d3f8e044deb7f5957"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db43f58e3c684b9f0b4f553ee40096e1a55f794b80dedcaf33f03631117e9430"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83f16fa16454b09340aafdc7ab065f0375adf28eeaff8c947a9b069bc740fea6"
    sha256 cellar: :any_skip_relocation, sonoma:         "89059e8e331c6026e7b95fc4e674d64e799b0cb0e024c27c82a8cb46ea4e421c"
    sha256 cellar: :any_skip_relocation, ventura:        "1386e8e61d766856c6a219b20ac98c633675adabd03a46f14c6ca8491bd1b5fd"
    sha256 cellar: :any_skip_relocation, monterey:       "ad438058e5a3434011c36bdbbd8f100e2bdf2e6f95310fa5b90f468152ce72ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4da3e5b4419126f13b77e39f133a194613516ce3c3beeb3582c6f4181756cd38"
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