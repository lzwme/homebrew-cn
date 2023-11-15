class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://ghproxy.com/https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.13.5.tar.gz"
  sha256 "7cfce349683e68145fcc1246c74d0b45097cc32b4e407d96b70576e38767942a"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0f4567ddeeb43b2ca4fb4bc444ea4457b54af6822528050bf3d8ce76bf661ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47b37e4a9ab5fcb86fb31a37f0ed9b97888a985dc7bbc4158ffaf70e0070f730"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2ad4c1e22229c675de878556c8378e2d06a6df900cdba1896423aa0c4a54f26"
    sha256 cellar: :any_skip_relocation, sonoma:         "63eb56dc843ef4e61bce6eb765255757bc428d4ffd550c83ff31078c30fdd751"
    sha256 cellar: :any_skip_relocation, ventura:        "0cc404e7f08c0988268b82c48dca3a2182c3e23829618d64581bc06abb3e9301"
    sha256 cellar: :any_skip_relocation, monterey:       "f845c008c06472f6a767909fb28a0cc0c99a0b55244c0e778175e15277439c31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f4cc9abb5486a52a8e2e3398fe567beed1346cfd280aa1b1c1fadb35ee3e7c8"
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
    assert_predicate testpath/"testchain/geth/chaindata/000002.log", :exist?
    assert_predicate testpath/"testchain/geth/lightchaindata/000002.log", :exist?
  end
end