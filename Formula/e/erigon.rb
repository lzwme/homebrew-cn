class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://ghproxy.com/https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.49.3.tar.gz"
  sha256 "974f2d27b413ea6c46a47e8d47f041145d57e12ebca9dbae7a6453c8af30727f"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36305e8e9be2068ca372f9793e87989550f96ce77003e877bfd1a30d61102d5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8063c476003a94bcee78cce48931d80527c6cd2a3e19498fb222a5bd48da4328"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0879af9a17cdcfff982713fcceeaa219029ce4537a22041601775f8512f27597"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca6e176facbc6be32d327801df1f55d5c6df2c0fca9d46bfb298a4dda1c4819b"
    sha256 cellar: :any_skip_relocation, ventura:        "6895740e8b488b6698e52febc84426b71c47577f8f6bd41bdcd088fbd0ebd13f"
    sha256 cellar: :any_skip_relocation, monterey:       "0571c768bb2c2cdfb0b18a07f87d6804e88dbb365d239b644f5718d6643069fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2a9ef2d64b2f20bb7df33c98ddea907b74f72a7e1e7af624276a7968b25d89a"
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