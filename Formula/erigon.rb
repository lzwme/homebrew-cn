class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://ghproxy.com/https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.46.0.tar.gz"
  sha256 "842a784b53fcf5eed878ee8c565b84722d52cbbe99227286586ee91632084d43"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99ea01d960a0823c5e269f93983ddee3a04aa560be979f6cd99f451232f21e09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f6618500d21b464bc612445a372d4a6056a679871667010cda341994c17a8a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abe2de5c2c2baff4deb9170c9209faff2bf4c58176b7d10373b6838892b60f99"
    sha256 cellar: :any_skip_relocation, ventura:        "5ce234cb2c0d496c5477dbbc0f039091ba10517dab434313698495e764d27885"
    sha256 cellar: :any_skip_relocation, monterey:       "93e42086f2b87010c67a3927759f81cf2656fc5b2fe5bef3acc596175efdb564"
    sha256 cellar: :any_skip_relocation, big_sur:        "0126224d83a8c4ec8e1ba0e4a781de898e522379815359e9021c73b4bb9a83a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ac5e1c9f43e8f3b734b058770d710d9e5f62e7b2ad84471074366a0984ca743"
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