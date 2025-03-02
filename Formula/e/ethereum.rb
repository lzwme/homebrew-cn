class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https:geth.ethereum.org"
  url "https:github.comethereumgo-ethereumarchiverefstagsv1.15.4.tar.gz"
  sha256 "6c93397f6e2b9641ff2499ebcea9691c2d6a743e47eb60512e643c3abc564637"
  license "LGPL-3.0-or-later"
  head "https:github.comethereumgo-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8afceda78fc238f9562a74e35e0eeb28ce9fff2a016dc52ef8a7aee297180e18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d980f61a73f5bfc8dca610cadc5a3f5e26b20a67d4816e52298da3c90dca904"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6de4f78c8bbf128af4d4a8e1643c10067b172402a7c74b4a49c1f53434f87d66"
    sha256 cellar: :any_skip_relocation, sonoma:        "9153b26ee560bc80206dbbf355b2654e1ec2ec594013b1b559712571259c06d6"
    sha256 cellar: :any_skip_relocation, ventura:       "5d0737eff2b87a5bc927088f499d034014290d54adffaa4e6e942ee65d49389d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e29588b2ee7f6137d1495f2d8a493b829ae6fdbfb17c367f65139368bb33640"
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