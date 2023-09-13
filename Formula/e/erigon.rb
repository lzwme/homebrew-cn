class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://ghproxy.com/https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.49.1.tar.gz"
  sha256 "484efaf4624d220b6872fe994f9c992869a90f27e86790f44d9e469242049fff"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcd4bc50806228ca045297788ad644819ce70950cc92fb72d33b8ea6d8ef5db0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62d8cb427517c4cfd5fc327b670965528ff609c76a319064aecbe1df0d30c9e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9a7016590f4a356cdb5ed53f1c5e5522aa982f114659bb9b197d7b62c50f169"
    sha256 cellar: :any_skip_relocation, ventura:        "9ab5d356169babc72d57513e54a67e4b4d539952fd8a4c3e500da95dc8ea3381"
    sha256 cellar: :any_skip_relocation, monterey:       "c2d0da867f8125646d018a6ea6220df1b09ff484db7023ff552c79b96304f2bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "90f2a93013439d43905e34232fb07a72cd2a00d5e313ce0c422cf5613a1d3845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e86905e05f3f7f4a5d23cb9db3189e9febde9605fff33fc15fed95236b037464"
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