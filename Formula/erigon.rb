class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://ghproxy.com/https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.45.3.tar.gz"
  sha256 "d9d57043cbf642483a2819e1a1bcbd0b12f797387a5d56002d0fd61ba976baa4"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe6369192c5eca50ef9e5de58e29b018f4bb63219da84b17b44e4dae95773fb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f70eae057b4053f3a872db23aedd5319e04e51425961f78a5590c0d9dec1326d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e4a64afc574f9e5ae3beaa7287df00f7192f1187a810eab88bccb1fac5d8375"
    sha256 cellar: :any_skip_relocation, ventura:        "0dbc1d6de83538d0e77ceb8dff54d68eb5805a934a6106185c66c7d4b6d835be"
    sha256 cellar: :any_skip_relocation, monterey:       "b96f6feec55fa93b325348da8e8243d5f119a55d195aa04f7df29be1663961be"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc4ac6af647e1b7aa1c47e396a1207732e1c8e78d49aacd178892a92295a3ee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "440d8ed26a0c49608a032f2e6da5cf386dbf3cd348dcaf0dc7cd9f132bc1477b"
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