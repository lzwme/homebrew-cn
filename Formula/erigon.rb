class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://ghproxy.com/https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.41.0.tar.gz"
  sha256 "24adbd77ffb162e27852ccb75d1c8f92f4a38f831d66ebec5bb33bd379a70aea"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9001ffea447d07b4397b4a31b46b8fc6c861f788e6f6afebcb26d20ca572e7e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cdf6ffa8f9052a2a2fdc23a2530e2bdc0defd9bd0c102e396563edb3bea6e8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb0609366c9c59ff9096a702d01d6f940123898290031677320bbd2a20034d2f"
    sha256 cellar: :any_skip_relocation, ventura:        "b6e90a934caedb790e833b325a1142a7ae051c6c92c6f25c13f24c08ad85180a"
    sha256 cellar: :any_skip_relocation, monterey:       "9bc8370d4cbd38530c3bf389a875037e8b7d0fc27ec9241902adaa7b546aae0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "52324917e19dffb6183304beb7b1b1840284bdc7c4034cdfec4c9f7a334b6ea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bce66539ff9830bcedabbb25a9a24d09cea270736041ea9cb95eecbb47f5c15"
  end

  depends_on "gcc" => :build
  # Build fails with Go 1.20 on arm64 due to https://github.com/prysmaticlabs/gohashtree/issues/6
  depends_on "go@1.19" => :build
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
    assert_predicate testpath/"debug-user.log", :exist?
  end
end