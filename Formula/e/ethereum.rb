class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https:geth.ethereum.org"
  url "https:github.comethereumgo-ethereumarchiverefstagsv1.13.11.tar.gz"
  sha256 "bc3c5e67fa94228d02e64e54baa1e779aa7a6c0f6a52195677ed9b4d70e57e40"
  license "LGPL-3.0-or-later"
  head "https:github.comethereumgo-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a0e96e7388579a31e1e45c83feb830467ac5894a8c3ad4677117b7f17a19675"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0cb34085819ba831a39cc364205b84ac46b4a47a0305f31ab86deed4a41284a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75d70b8c5769dddd219cc2f8971a30da64392e7dd037880ca46b0a96c96747ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "f193845928034ed6810c89b1a37bd81aa304aa5cafbc1330da9354474dc6e84f"
    sha256 cellar: :any_skip_relocation, ventura:        "c93424d6509f90a0ebf2a9142cf870c8d975d591dc2d401f5f46944f8eb3797d"
    sha256 cellar: :any_skip_relocation, monterey:       "0e931d7ac0b7ce08dc77a731a47ba5f885ef3ae5a7800a264aa2b11fffe09f5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "345280dc925d222f0704bbddffdb46442c593ce63ac91a584ad729228545c072"
  end

  depends_on "go" => :build

  conflicts_with "erigon", because: "both install `evm` binaries"

  def install
    # Force superenv to use -O0 to fix "cgo-dwarf-inference:2:8: error:
    # enumerator value for '__cgo_enum__0' is not an integer constant".
    # See discussion in https:github.comHomebrewbrewissues14763.
    ENV.O0 if OS.linux?

    system "make", "all"
    bin.install Dir["buildbin*"]
  end

  test do
    (testpath"genesis.json").write <<~EOS
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
    EOS
    system "#{bin}geth", "--datadir", "testchain", "init", "genesis.json"
    assert_predicate testpath"testchaingethchaindata000002.log", :exist?
    assert_predicate testpath"testchaingethlightchaindata000002.log", :exist?
  end
end