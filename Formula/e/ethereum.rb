class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https:geth.ethereum.org"
  url "https:github.comethereumgo-ethereumarchiverefstagsv1.13.15.tar.gz"
  sha256 "d5265c17029287a9e0422b78e52231944b1bef40bb2e4036e4da5c49da467f12"
  license "LGPL-3.0-or-later"
  head "https:github.comethereumgo-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e724aa969fb8c363c320a6cf0b4279308f50f9b6f187b878ea58d4874b80969a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "517ff8a590df78c62c81f676fa04bb46c1e3ee99c6047757a022a735de8bda4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd69b6ad81bb92531b813b1e1dd26409d332b12e747a6dc89df6b0c643ae18b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "96524dd4cac5554461a5e2aa42b3bed787321189f0b703ad5276e0a2794787cf"
    sha256 cellar: :any_skip_relocation, ventura:        "ba97db19f7bb0bdb5ee52bb71e7e9f8e368966ac7d7b1caa311eddd8f929ac4d"
    sha256 cellar: :any_skip_relocation, monterey:       "0a1924a2ddd22731afcb545a9e9776e080a0e04a96b246661effcfdf25e4a8a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "639f59fe86e95645d0dd3fde14660e433d623fef459d44674f631cf4a8522076"
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