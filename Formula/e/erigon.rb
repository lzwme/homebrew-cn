class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://ghproxy.com/https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.53.2.tar.gz"
  sha256 "17c92ecedca7cebde9ff8ab09104390c4583419cb96fdec3946bb8cbe3903f0a"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb22d93b1294112c7c9ba6b595f28e443574d3a71e9f0b2001927e0638997cd6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cbec4555f87ec9153d7b803ee6682236960d7b39cc41577875a6fd15e38e25a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c9be4d08ec4c6367e23143e4f1f63682461b4825a47bfa6747ced715d1f46fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c27f5cfc84a33126f110447fc83cde3ca9dfa12ce4a0d4b5f48fb43981763f4"
    sha256 cellar: :any_skip_relocation, ventura:        "22473c3640393e6232b160ffabfa272b2a94fb7d7d41bc42c8b33acff74e3585"
    sha256 cellar: :any_skip_relocation, monterey:       "8ea52135a535d9afc34cf2f01521bb6441ca7794d66b783a226aea328077c488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82bea535a5ba96665b2b95f2676bd14677cac72c382400e8c9344e9464a2b886"
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