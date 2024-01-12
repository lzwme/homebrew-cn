class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https:geth.ethereum.org"
  url "https:github.comethereumgo-ethereumarchiverefstagsv1.13.10.tar.gz"
  sha256 "109ec6db87ccfa6854380a37bec7ab690bd17f52f47018f16a6c670a6368f9cf"
  license "LGPL-3.0-or-later"
  head "https:github.comethereumgo-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da562554bcead84af26acf00cb8dc0983c77aad7eff41825b08a65838aa553a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8ea9ab7ee5dbb1398699eeaa3bd896fd65f0c77c5194309694ffbf963a54039"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06d8cfc6bd223157cc3a533691b34f3febf8d900119a0cde052b1ec0a791dd94"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c596a859f1b40a7fafc24c16b57973c92c46b933b6dd773d8481a85592d7c88"
    sha256 cellar: :any_skip_relocation, ventura:        "9b7f8cdf74bed1258ea021d51fd1cf373be0fd6793bbef2a949241baa412fc2e"
    sha256 cellar: :any_skip_relocation, monterey:       "461e42263b66e2270417059fcd55ef9e8688a0a177182786e039889ae9acf67c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b7fa56aaa6d3035a7fd96d70679af6395eadcd159fce45223ddeb7cb4fba04f"
  end

  depends_on "go" => :build

  conflicts_with "erigon", because: "both install `evm` binaries"

  def install
    # Force superenv to use -O0 to fix "cgo-dwarf-inference:2:8: error:
    # enumerator value for '__cgo_enum__0' is not an integer constant".
    # See discussion in https:github.comHomebrewbrewissues14763.
    ENV.O0 if OS.linux?

    system "make", "all"
    bin.install Dir["buildbin*"]
  end

  test do
    (testpath"genesis.json").write <<~EOS
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
    system "#{bin}geth", "--datadir", "testchain", "init", "genesis.json"
    assert_predicate testpath"testchaingethchaindata000002.log", :exist?
    assert_predicate testpath"testchaingethlightchaindata000002.log", :exist?
  end
end