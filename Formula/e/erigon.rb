class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://ghproxy.com/https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.49.0.tar.gz"
  sha256 "44c1103495e79cabbc6dad0242582a3522d5494bb7058c05bdb6e0ba2f0fdd6c"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f69470e466c9ebbb2206746cdd3a87da94247018ccb01fe536bbd4edfd66653d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e5c5272f84d1801431b9a261196e8cdfcd3121b33c32d4a39e088cf4b2d7a02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff19844941633e4d2fd6aa8082dd068d8102ffb9cd573e2814b9fe2edca5099c"
    sha256 cellar: :any_skip_relocation, ventura:        "5f9ae994fe70a1a8973691151c6e609e904be9fd55fae135ba1d5edf95cbc988"
    sha256 cellar: :any_skip_relocation, monterey:       "2f5095adedaf00ab9e5c2c9fc7196d1ca4cf146cb2bef19ff9502d90650f7b48"
    sha256 cellar: :any_skip_relocation, big_sur:        "919ec2c737a3f897e48642216906a62e22134294e1088fc254fcdfc8906202a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9277b280182b8476a9323d58b038074dc1a42e61d8e0268f5467f5efc22d9c0"
  end

  depends_on "gcc" => :build
  # upstream issue to support go 1.21, https://github.com/ledgerwatch/erigon/issues/7984
  depends_on "go@1.20" => :build

  conflicts_with "ethereum", because: "both install `evm` binaries"

  def install
    unless build.head?
      ENV["GIT_COMMIT"] = "unknown"
      ENV["GIT_BRANCH"] = "release"
      ENV["GIT_TAG"] = "v#{version}"
    end

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
    args = %W[
      --datadir testchain
      --log.dir.verbosity debug
      --log.dir.path #{testpath}
    ]
    system "#{bin}/erigon", *args, "init", "genesis.json"
    assert_predicate testpath/"erigon.log", :exist?
  end
end