class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://ghproxy.com/https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.44.0.tar.gz"
  sha256 "dd9da0fc581d37d0fe386693cc611a37cf7b890bf8bc7549cc0c88674322f72a"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38386ccc7e9caec4d832ed4e968e5227b88c6b0188ec9e3777c46c98e92cc35a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a47a4bf3613806c4e0d50d1d3bd8054dedf958c3740f9aa72145ded163b57c83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7bdb293c0def0db2cdcfcebbb021ecc74e96487fc52a429e53c3ec64c0b0ca9"
    sha256 cellar: :any_skip_relocation, ventura:        "d58b1cb84669f2d6f70c36667de29bd037ed05c2051b1e4c3ce90df7745177d7"
    sha256 cellar: :any_skip_relocation, monterey:       "f7adaee52e9a90f58c50133375a5def38fc918183b547f8aeabf54d72d010274"
    sha256 cellar: :any_skip_relocation, big_sur:        "864c09cf1a7d09175f200de1a98c9cc06b661627efb3bc3d6633e0f838159b86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c95813810cb7a2b12e00b2ab87383f90c897ea90cf8b7a212bf1b0cd62ce12cd"
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