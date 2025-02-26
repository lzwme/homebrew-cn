class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https:geth.ethereum.org"
  url "https:github.comethereumgo-ethereumarchiverefstagsv1.15.3.tar.gz"
  sha256 "5eb6ee2a38c2cf27081589bcebd2f866cf52afbcba21a723227ab21cc468f7cb"
  license "LGPL-3.0-or-later"
  head "https:github.comethereumgo-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c43cac414a697a604522f4a0bedb3c4052c2b1840bc371fa9685444fba6ccbfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99d9b9b3b13aa223d79e63dd078e426ad2409d66f6fe484df633da917f332f3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb34eb456cca5be4f4caf1f8c75063be7ebb133227c239f1937cf366ae025c5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb70fac53fb6650650024a3990d40e33a22881e7de2931bd1b34cf3e13c4e53e"
    sha256 cellar: :any_skip_relocation, ventura:       "36569d28f61367c2ab31841d86141b2e85a2ec440de9448cbbd09f311112c23b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4b879f33bf2f394933a1e7997fb85e26add0c555883d1f8f24cec1c6d291a41"
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