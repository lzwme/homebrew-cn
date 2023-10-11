class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://ghproxy.com/https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.52.0.tar.gz"
  sha256 "06a968271d46982528dd9b69f1a5835a18c3e0f73ac00051c79009642c8715b7"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1cf2cea6d79a6fc17e004524cd21f3afc111122fa437ed1172c575a2e00473f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8c264c2c844e491b0dca84eb2f3d23ba16e4e7c207a6cdc0fe89c3d4dabb815"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7441dcee7d14a9492e93638e8da34ec691edfa6109339eb24d28419beba2439"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc7abd420349f20a80096183e10d3df41f82b06aaba01539da9c17d3f25bb0fe"
    sha256 cellar: :any_skip_relocation, ventura:        "6b239c34b30678e4e08945eba2206e63c10c97959c43e8b406fc7421602e399d"
    sha256 cellar: :any_skip_relocation, monterey:       "64d002aefc5faf96d2c383f397153eb0e8d6885b774e12f2195eec416d1c3983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6af43e11c8457d4f69fcf1363782767b7a53effdd40c1fdd6572877c165f988"
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