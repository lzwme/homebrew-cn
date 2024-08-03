class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https:geth.ethereum.org"
  url "https:github.comethereumgo-ethereumarchiverefstagsv1.14.7.tar.gz"
  sha256 "c5ba6f30385f761207cdf307b95cc024ce6fd9700830a2626d17005486b18766"
  license "LGPL-3.0-or-later"
  head "https:github.comethereumgo-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32b18df4c841e7bfbc0d1faff2ef784d8e950daea13657642bbe6fe8bab08f36"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33d1c49545e6d6230df1a37a91cd8116dd25e02d8c6e9540362a424ff116b6a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b07625af672f51a4aba64bb58fbeb1d17f63e1c680a27c4fc1cb24452d63f8d"
    sha256 cellar: :any_skip_relocation, sonoma:         "73cc382c293eef0425b7bc0680a07bfcd842b46829f3b9e0d6be74c522b7acc0"
    sha256 cellar: :any_skip_relocation, ventura:        "7db65406cc2d9e92bd97c5e17614827aa69bedf98725e2e43d6e85a302dd70ec"
    sha256 cellar: :any_skip_relocation, monterey:       "3a77469ff922e28bf38bdd1c71ebe7b7b095f3cd8f8f06f62c973431c325735a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35c56528c579bd6666a0817a5aa3ac964e44b5dde38a1aa9153507efbf15f604"
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