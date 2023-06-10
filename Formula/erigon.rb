class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://ghproxy.com/https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.45.1.tar.gz"
  sha256 "727e0517d1ad1d049db30db180e73bd0bdc62aefa00db50087bf11b5084b5bca"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f73955acc447405d958fd04805de9617e40f99f9005cfacdebc8429967f83c4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e3e5096cd5842c40394c919eeb9521b8c9ca689c8ff46147f7b4982c71a3513"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "538dcae218a30fcd501fe51fc289d7b372d6928c38110f826dbe15f620af709d"
    sha256 cellar: :any_skip_relocation, ventura:        "e8fc134b8a01723d198d4bd2f2477f7ada4f940416f86bfb4171c7e007e8a47a"
    sha256 cellar: :any_skip_relocation, monterey:       "27fe9b5c929c223010ab15192944daf1adde29a60148d1a4bd731ec1b9ae61e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d70ba2d83d5437809018a57ac9aca51d44affafa84a4f05955f84100a739deba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffc95e70b873f9bdd03e0783c49669ca6124452a691ef241dcd8b604c3160784"
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