class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https:geth.ethereum.org"
  url "https:github.comethereumgo-ethereumarchiverefstagsv1.14.4.tar.gz"
  sha256 "10d96bfdf7cd4291dc559691a54b672e1eb28444b52e163fc78ee54116a7d333"
  license "LGPL-3.0-or-later"
  head "https:github.comethereumgo-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "140e2d6b8161437278d1ecb71ec94a8e2e2d5e6781fd640428e62a339282bd8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "717152d7500f0a10086f31d08e13fd08c8c32a0b153a7a8bb46ee7353d87502a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "746a5c9a98462e2f2f3b894669bd2feb91253e5255ad4a8161696782713c572d"
    sha256 cellar: :any_skip_relocation, sonoma:         "43098470ccddb01806e0fecff6ff3f70b6b3fbaf5eda934b28891ed7c5d56417"
    sha256 cellar: :any_skip_relocation, ventura:        "b2e075a03596e15e6aac21e0f4e6b542e6c2db13ee53de9825da29c008fd30ab"
    sha256 cellar: :any_skip_relocation, monterey:       "f8c8adebd2d6ac45763a1fb1db1c1336c40f806f534f6a3f8149f3dc0a23732f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "914fdb22f8448bda5e203f6da581981fa88c00fd291af7b7b5712d077a632355"
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