class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://ghproxy.com/https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.50.1.tar.gz"
  sha256 "6695d0064547e3c7c425d932f47a44ff1b54d10d734b103f210624e64760eb93"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a61e57b3feb8c069775bb2cf9a7383c7661e3bca0fde76e6f0b2a81d496be938"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4fda804fda44be3551ac5c3a0ef5f541d874be882efd7f1ff9d33b106725c96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4eca443fd0aaf2cd306bd7d4b8e9768eac0697617e122d0f57de34b12e1c36a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "33fd7682e9f25ea508e9dd85cc6a576d189fb3f3394faa5256f36aaa57cceb8f"
    sha256 cellar: :any_skip_relocation, ventura:        "0b034b55f40027237b44d56ea2eee8994bd07ca73e70158bc37fb0176f41fcdb"
    sha256 cellar: :any_skip_relocation, monterey:       "f5ed5a4ffe18603229b927ee159c2b26d4b2ef5f78b2dfa61f994e68b8519bcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98148397dee3fd2f8b2351cdab29ca46ba353e1809a9293091948086f6315707"
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