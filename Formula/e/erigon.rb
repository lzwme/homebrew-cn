class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://ghproxy.com/https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.54.0.tar.gz"
  sha256 "7fe330bbf6edfdb1b84356e639e04f545eb64b97e2abb51d41f895ef993b8fa9"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc899694ccdb0e71b77726df29b5cc620600e57a7df6325f2f5fb21dbbe8c704"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa2dea64f77977467fd52ce32d16bbe3df515351d99c65737ae748191ea05d4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40ed34192c78fc9807b8be57deaca4e5885cacf933fd35502ffa9eb202db3663"
    sha256 cellar: :any_skip_relocation, sonoma:         "19edcf702f80192c0c483bc2fb4ad2dcee6f20b4b075ca35c922d81d45e3ee46"
    sha256 cellar: :any_skip_relocation, ventura:        "3b0ac1c74a5aba4642eaa004b11d937c825dc5fc88f15847022ed8cde1edf3d7"
    sha256 cellar: :any_skip_relocation, monterey:       "a175fa0cd1dd879034d7e4ee48c3d5485baa777946e1e1ef8454c38c3487f539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a64881b7da3a0df35f82393d9ccacf23ddc98a27f0f7f37a725bb34341401c2b"
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