class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://ghproxy.com/https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.50.0.tar.gz"
  sha256 "b07e694b5b84dec5264cfc4d91d02f3e1da5552fb58c49504db0af8498f3a654"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "042e5806f2a980de701a05a3b1cc025d6f4f94c7b8f8202ba35ddfa905931493"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59185459a841218ba7ff1ec32739978651987eb92ea1fcc3e4e0ccb0b98f50b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "241af05bbcd968287a13cdea51261b11fd9357a30635705edcceafbc75419bb6"
    sha256 cellar: :any_skip_relocation, sonoma:         "149f3dd45fab44eabd7492d64fd3beca8390ab472ff324077c6506774dad062d"
    sha256 cellar: :any_skip_relocation, ventura:        "abf7056588105f914ee8ff850d2b24e2841a60f6364e03d51dfdd697fba7c6a3"
    sha256 cellar: :any_skip_relocation, monterey:       "031a0735aded44cdd8be868a7bec6407c85376d0d5a9dbe9a5e4a8bb67c74a58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a027142f52147ee6d80fd2c9c979344f268909266ebcd14ccc7c41abbaf493d"
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