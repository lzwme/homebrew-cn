class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://ghproxy.com/https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.53.1.tar.gz"
  sha256 "ddfaca02d88458d73c4ff8da5548da6c106cb4b4775816938c44361e74538f6b"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b30dd3b1952f7847690adcee15d3846f803e91ab2155dd1de204260ec559797"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f562e505ac7564c701b803c033528dca4b38b060ea9591ab915566dbe270ca4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71ab0bdcf7eb3bef540249e658613a3035d5df7aad24448789e0a2e441cbf861"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7054a0788037dff17af2cf8dac4c02b69369ef3fe3bddb4860ae31418f6fbf3"
    sha256 cellar: :any_skip_relocation, ventura:        "4c181ffaa612b2efadb88c62d9e92365758e47386ddd3d0ccf99964ff80302e4"
    sha256 cellar: :any_skip_relocation, monterey:       "91abf29e7a517dbd2ccc66cf6e42e7e09e6e6e22252f96838a4d09db4057d12d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54b106cfd25eace2d3c96fd98df758983ea04055157555cb22ef5d7c0df26755"
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