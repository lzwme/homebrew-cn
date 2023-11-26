class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://ghproxy.com/https://github.com/ordinals/ord/archive/refs/tags/0.12.0.tar.gz"
  sha256 "6c531fcb106e13ad8ee9b39d17a99183b9ec678129ba79c3fdef7f2f9afcdaba"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f06cde9b50cf6337a03d16df03ddd5b3c8a26501c61344afbb28443d15677ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bff163bc6e968ffbcf4a5664a22e2940c3ffb4b529da36ddf19616e833339db0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b77e50a8fddedaf5b1e7b49f1b186b814e49a950cff8fbce0244aacbb83d2149"
    sha256 cellar: :any_skip_relocation, sonoma:         "336e23af854f13c68722e1d0dee6ce423205ea63aacdad74cbf2dd155c1cc8df"
    sha256 cellar: :any_skip_relocation, ventura:        "c0a390b313f4cc7d69fab7fe438fa2a6550edc8aa45dd4aab20629d739709abd"
    sha256 cellar: :any_skip_relocation, monterey:       "0d4c5fab936b4c5bbfe38fa810d7466c41a76180ad36eab00e6a3e5c47c12480"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c727798c6276cee3ba2110869101673cc61105042e35cee18caf78fc8bba51e4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected = "error: failed to connect to Bitcoin Core RPC at 127.0.0.1:8332/wallet/ord"
    assert_match expected, shell_output("#{bin}/ord index info 2>&1", 1)

    expected = "error: failed to spawn `bitcoind`"
    assert_match expected, shell_output("#{bin}/ord preview 2>&1", 1)

    assert_match "ord #{version}", shell_output("#{bin}/ord --version")
  end
end