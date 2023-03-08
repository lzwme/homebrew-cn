class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://ghproxy.com/https://github.com/ethereum/go-ethereum/archive/v1.11.3.tar.gz"
  sha256 "46b08903c26ce14f04a4aca24b154ef2e7f5dcf20feaf257cc8a8653dc1080dd"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32055970a33cd2255ba66f91818e068b93690c2c444ca48b6382872b1c1eb599"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63329aa7fccb9b55c444b6454865fcbc650a5aadd2f42f50318fbc7116cac1d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8d9d967573da731a2a6fc117d34ab46143f033f863fe00f7bead9c3c3c10df2"
    sha256 cellar: :any_skip_relocation, ventura:        "5556f42d6ce2bffaf7c762a25fbe6255ce723490f7d36387495bae7a4ab0d880"
    sha256 cellar: :any_skip_relocation, monterey:       "68a92b6a2f39640acac128fceaa2d7854ddfb5a6e0dbae961a7e80ff17435226"
    sha256 cellar: :any_skip_relocation, big_sur:        "99c60c039a6352fd3949c774b7341741bafc158a26889593dbe8b0a77fd8ef45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9206ce39dae1592f2c1cab57d6e44d285461b93451f2ca2d6e65e9add1dbc926"
  end

  depends_on "go" => :build

  conflicts_with "erigon", because: "both install `evm` binaries"

  def install
    # Force superenv to use -O0 to fix "cgo-dwarf-inference:2:8: error:
    # enumerator value for '__cgo_enum__0' is not an integer constant".
    # See discussion in https://github.com/Homebrew/brew/issues/14763.
    ENV.O0 if OS.linux?

    system "make", "all"
    bin.install Dir["build/bin/*"]
  end

  test do
    (testpath/"genesis.json").write <<~EOS
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
    system "#{bin}/geth", "--datadir", "testchain", "init", "genesis.json"
    assert_predicate testpath/"testchain/geth/chaindata/000001.log", :exist?,
                     "Failed to create log file"
  end
end