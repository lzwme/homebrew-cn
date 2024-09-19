class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https:geth.ethereum.org"
  url "https:github.comethereumgo-ethereumarchiverefstagsv1.14.9.tar.gz"
  sha256 "078c9dba93e3823061754eb55dedf5df842da4d315d7bd824b5076b1cd595ad7"
  license "LGPL-3.0-or-later"
  head "https:github.comethereumgo-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45bd28b62e2d79b4d813b38a9c7cbcc52a821ee05abe0e52597921fd8733a3d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8f7bd8b67c18f18a612a7debf740f1383c4fdae23fc81d92fd279054b449da9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb1675948b78d971bde52d55ab560ff024107116c00f745c8beae8bdc0cf014c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3971c4277a05d3c4e67f15cb33ffbcdb44d020f41bc3388835b8ab31347b2b1d"
    sha256 cellar: :any_skip_relocation, ventura:       "589ec2f5d0d8008633e243cbc35da41a64a0cd9951b55cbdfc3d9c365e125abc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c6ddac92620d7369acecd70dd7d768045a93b689482f45f3d7a88bebcb5d049"
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

    system bin"geth", "--datadir", "testchain", "init", "genesis.json"
    assert_predicate testpath"testchaingethchaindata000002.log", :exist?
    assert_predicate testpath"testchaingethlightchaindata000002.log", :exist?
  end
end