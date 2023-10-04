class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://ghproxy.com/https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.50.2.tar.gz"
  sha256 "b8c1c37da4e38761b69fd9199cff2c1688fe80cafe76502b6a2f5bc8c1144f04"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d867239d42ea4c64e2a7fed2264e5eee2837383a1b45499343010bdcc7cb9951"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98d8426e81a0b00140ddddf6911ac2c2df0dc57a277e112a9abffd2555617df5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10b7637e647859974225cbcbe70a6a20706b09cc9ea18323305fdd43dacc73b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "db2ff3b333afa6d0a972849e97bc9bfc86f8d7053caaa97b224e6f75c153265a"
    sha256 cellar: :any_skip_relocation, ventura:        "aa181d341676a78aa74d5ff15eb8206f344a3f2667a87bbc1e1905b7db6af1a0"
    sha256 cellar: :any_skip_relocation, monterey:       "68c10dc798425b21e7310e6e7b6be70d97f1d33f1d47ecb18c4a00512884b5a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0478b2f86a56e90e5a5712d00544b9b75da0a2681a2c49ed37ce72177a593ba"
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