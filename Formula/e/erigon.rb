class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://ghproxy.com/https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.53.0.tar.gz"
  sha256 "7a02c2e0afc2d52661b28dcdd9ccd8e5c37b6ffd423b096926af02411492c39d"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee733ba2407b8857615cbc428843dc6d891fee4df85d3566c45d2ac51691960f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be0a50c12917131d065f40c701fdb58412accac204f072c2adfb1c56ca76b07d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f684a44608c0f2e270ed90816f4c5b4f5acb12787b1949801f4f4e112c9e6718"
    sha256 cellar: :any_skip_relocation, sonoma:         "317cae32ec67767486ec426402ca1c20afaeb0e7a2747ca787505a786143144d"
    sha256 cellar: :any_skip_relocation, ventura:        "ee616a1b8903f0e10b1f4ebe5dc5a2ce413e740743d84fcb7a90dc7b94d32164"
    sha256 cellar: :any_skip_relocation, monterey:       "95d026864bf3b1d1450d48365d903605ae4b3b816259d980700ab915581b7632"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1924d61d3edcd20985f485ebfc288486158723bafde40f2c514eee69c76d3457"
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