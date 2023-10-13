class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://ghproxy.com/https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.52.4.tar.gz"
  sha256 "62357912c787258a555366768f92b1c3ca1daf30b0a7c9596ff81186be9837ac"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10406b41695448fdf6f38b55b43ffb1db67f11a9925f945b750993e6867736b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b05fb7e9a04dc26bc8cf51290cb6a154be0a54e59dc2ab002468c5244ca811e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d43db88af77d4e234898faf783ee7b1d4517f3ca04a1c7c481cb1d866bdd0287"
    sha256 cellar: :any_skip_relocation, sonoma:         "2882d7f3305e93b88338df5ce4c49619a4e996a20cdf9f71b28df2b2c382df32"
    sha256 cellar: :any_skip_relocation, ventura:        "3720fee68b7063cc7421a4b9ac73735eb9302e7cc6fcdb99746458c37ef397e7"
    sha256 cellar: :any_skip_relocation, monterey:       "27b27dd07b375eb10a756b9c28e7b22bb09e8c637e8e654c751c0338148fd626"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2ba6cbefd1bd5aa6273a4bf44ed9b12a15fa83d49396062d1b19d3bc80e3aa7"
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