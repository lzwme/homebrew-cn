class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://ghproxy.com/https://github.com/ethereum/go-ethereum/archive/v1.13.3.tar.gz"
  sha256 "c5bfe22c29e4eb1b61d620a02455eee76f3347d2ff932c74c1cc479bd3dde62f"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a377e5adfe1abe523a00bcdb5f991a9f87d8fd09f85009df512339c101bb3c06"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2ec9e072fca48e3cda30e80bb04dfd44f7a54f7bc9751372bdf6047c699fd18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5477adaa65737fb09880e7a3602d9ac969fbd12b9814580a84b379afd5cb0454"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7776645fd1620818fb34169738f1da3ff821af967a533e7dd7b3cdebea49c40"
    sha256 cellar: :any_skip_relocation, ventura:        "32018ccf6a98fcd15a9437fea59a3c88d75e00a81a4d4c8d46dc54fcff9a9bab"
    sha256 cellar: :any_skip_relocation, monterey:       "0331785883bd22714404517f7e03844f106c5ec0d59d3c6d86f9d29622cf9fe7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77526344af4eae806eddbeeedef769b875be97fcecb75a78d048ad167813e0b8"
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