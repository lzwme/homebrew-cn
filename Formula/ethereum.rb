class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://ghproxy.com/https://github.com/ethereum/go-ethereum/archive/v1.12.1.tar.gz"
  sha256 "44946e4f0fe8c2c4caaf8774cd001a4ff645bf22d9bfb92583995e97f705fb41"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a90ce299b6ea59cc82a1e4f74241b9c000a061d9f50450a1e5f5a9681061dea8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d1441377f996850d6fc67f256bfa7126f5dba1ca2c988368a431742ccab1819"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29a5c8b32468fc49d303c6803efb8929d729fb3b271f201aac483350712a3fc7"
    sha256 cellar: :any_skip_relocation, ventura:        "d6752c45977723c6ef71541947adea86a7cd95293ae8cf34b267fe00489b6e24"
    sha256 cellar: :any_skip_relocation, monterey:       "0f54cc91ed3aaeff40e753c3e63192ceb81fa8f54525516ac8dcbff6f22dd87f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8eb2731c6221cf4a0d603fb0e43bf1ed73b74fe686eed5fa191880e9b026056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8c4a2ec83c34ac284b4b4f8587603b090cc193c7f732fb2d0ce8f0dced23292"
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
    assert_predicate testpath/"testchain/geth/chaindata/000002.log", :exist?,
                     "Failed to create log file"
  end
end