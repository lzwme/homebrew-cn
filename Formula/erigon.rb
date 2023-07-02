class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://ghproxy.com/https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.48.0.tar.gz"
  sha256 "2b3f496523f96506da12ae118f45a5799f5e73e25646754280de4c3a3440d4d7"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4abaad71a912f0db1eba7966363970c8ecb3f29eda8984bde4628fc89b840d93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b0848370cece2cc2fda6de713b3ac78d7ba78988ac57f32ea2508b792ac1add"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87dc41672b716294ca6ad7953d736c9b2f7d5b41ce08ec8ab3ad27347eb99113"
    sha256 cellar: :any_skip_relocation, ventura:        "764b977a91bc83ca91bf5ba9aa571a79079022268054461a8fd489143b97c772"
    sha256 cellar: :any_skip_relocation, monterey:       "f688404f0bcfa29a61ae73e63a6931ff958b1c8a07263fbbc9c14c539dcb9b02"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f87bd4eab1e271b7fa28a4e86d2f5c4ff8bf038d0e914e01f3476e97b78178a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56442d6d16fca500931a54c5deafbc922117537f632882ed447ce316184e5ab5"
  end

  depends_on "gcc" => :build
  depends_on "go" => :build
  depends_on "make" => :build

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