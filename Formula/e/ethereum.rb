class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https:geth.ethereum.org"
  url "https:github.comethereumgo-ethereumarchiverefstagsv1.15.2.tar.gz"
  sha256 "1728ae14d728d4ce86a840ee783d73dd9cffe9e1dbb82ecc032e8b93a9841cc4"
  license "LGPL-3.0-or-later"
  head "https:github.comethereumgo-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf37125a98b59d964437bc25af0d2eb7363f685e6fdd277f0f924022aeb444d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "734ef3c02ca22958596ca7187b58434480c536d4076a7a6a6298e89faa1b4b65"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b29964d1f4f1c0d91e60771e53f7d2218bf4fc3245a43f1d7a630f82dc2a0ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c9004f938eaf735432a917a8b0d3ec57917a09114631f195ddca53e99bfd06f"
    sha256 cellar: :any_skip_relocation, ventura:       "628094cfeec24f248bb189214199ad9b01c81a7ab62d47bead90d6d3dad9e379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a8f8ad3c3324e670c9d791688c54a751c4b2e6e78f0b75781f4770db6f2d1aa"
  end

  depends_on "go" => :build

  conflicts_with "erigon", because: "both install `evm` binaries"

  def install
    # Force superenv to use -O0 to fix "cgo-dwarf-inference:2:8: error:
    # enumerator value for '__cgo_enum__0' is not an integer constant".
    # See discussion in https:github.comHomebrewbrewissues14763.
    ENV.O0 if OS.linux?

    system "make", "all"
    bin.install buildpath.glob("buildbin*")
  end

  test do
    (testpath"genesis.json").write <<~JSON
      {
        "config": {
          "homesteadBlock": 10
        },
        "nonce": "0",
        "difficulty": "0x20000",
        "mixhash": "0x00000000000000000000000000000000000000647572616c65787365646c6578",
        "coinbase": "0x0000000000000000000000000000000000000000",
        "timestamp": "0x00",
        "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
        "extraData": "0x",
        "gasLimit": "0x2FEFD8",
        "alloc": {}
      }
    JSON

    system bin"geth", "--datadir", "testchain", "init", "genesis.json"
    assert_path_exists testpath"testchaingethchaindata000002.log"
    assert_path_exists testpath"testchaingethnodekey"
    assert_path_exists testpath"testchaingethLOCK"
  end
end