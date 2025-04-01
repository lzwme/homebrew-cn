class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https:geth.ethereum.org"
  url "https:github.comethereumgo-ethereumarchiverefstagsv1.15.7.tar.gz"
  sha256 "2711a4eb24b5d8785cc4edc3ca907a0cdc147afc02fbb55b7021a405d9ef5518"
  license "LGPL-3.0-or-later"
  head "https:github.comethereumgo-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb3a13f325ad4445bc721c8b16f77cd84441a58b50928d0fc9108c21b89b66d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fc53ebc2e9d6ccb44822c42bb0213b93230b8dad0c1373ed4adec2b17e48545"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5df818af70e9a0744f22ed1ac727ccef528ac2d03577d5b51537d60a14b049ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "58534d5a1ba3b2cd5106d59cd226c5f770f17de157977586d54b97883d79008c"
    sha256 cellar: :any_skip_relocation, ventura:       "cc9d9babb3da65b7366fb9c25c07b55c3771c2e6c8e3bc8d08b5a7d00d20b4cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7f64a36885c6c5a8b3af3e56538f39a7711b94c91df6ba0eaf04220e77cdccb"
  end

  depends_on "go" => :build

  conflicts_with "erigon", because: "both install `evm` binaries"

  def install
    # Force superenv to use -O0 to fix "cgo-dwarf-inference:2:8: error:
    # enumerator value for '__cgo_enum__0' is not an integer constant".
    # See discussion in https:github.comHomebrewbrewissues14763.
    ENV.O0 if OS.linux?

    system "make", "all"
    bin.install buildpath.glob("buildbin*")
  end

  test do
    (testpath"genesis.json").write <<~JSON
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
    JSON

    system bin"geth", "--datadir", "testchain", "init", "genesis.json"
    assert_path_exists testpath"testchaingethchaindata000002.log"
    assert_path_exists testpath"testchaingethnodekey"
    assert_path_exists testpath"testchaingethLOCK"
  end
end