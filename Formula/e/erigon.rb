class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://ghproxy.com/https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.55.0.tar.gz"
  sha256 "ab6b76f87469d7ee803e1d4090b7f283d8494bfa6a6be7e45cd9de44eaa80e0c"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50e1b2d3ad262680e4f9d9a341df38f7d026e53a1396a8bee2089cca2fdb7164"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1c79a7f979fb3a851c6fe6f78cb951d9d0d7324c6e1590116bb38286ffd7ba8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7e9440aff8813f95a7283cd5123ae8eb5dba42963bc8b7a3d745ed90a0f11b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "f87c57059b94e61fd2fb9a245306f00cedbed0962aedb7df70e287a061223e52"
    sha256 cellar: :any_skip_relocation, ventura:        "9cbd78b802c7d32b06133ae3f6e90351de0f1dd432bd72e9b43d52e478a18879"
    sha256 cellar: :any_skip_relocation, monterey:       "3bda390dcc975daf05cc3b03233dd3a280d61aba9df1a1bc1c2cb0eac9d0c5c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d5d0088d25a9134cf6eaedc2a8c7f954d940f4c32aa4fabc7e6d564fb3d5349"
  end

  depends_on "gcc" => :build
  depends_on "go" => :build

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