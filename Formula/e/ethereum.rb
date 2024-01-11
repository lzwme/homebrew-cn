class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https:geth.ethereum.org"
  url "https:github.comethereumgo-ethereumarchiverefstagsv1.13.9.tar.gz"
  sha256 "e9f29d6575d69f2bb36e0f463b57e15582b9fcf0f73395f31025332a36749db7"
  license "LGPL-3.0-or-later"
  head "https:github.comethereumgo-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b3ed2337139dd54f6fd2b4dc46a1f6bfa0c76b8a5655b9bd86a336357a9eb9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26998cd75a1b57bcb1af669bc60e7017ad0ea4b82ee1a118fbc59eb9261e06da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4f199e3f45dd246b8d249310ff6e5a9f6772606617776caa99c1a12d905e101"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9ec58988405a4a20af3322d590b026dfaeaddf750c381812c8457ba348bdea4"
    sha256 cellar: :any_skip_relocation, ventura:        "41a4045a5c96d6a3817d70cd805f41cdf0a812803335731537136c31b410bfc4"
    sha256 cellar: :any_skip_relocation, monterey:       "36fcde26d8088c7b5736ab3724640f6e3337ac2d1f1a3e78c49c53c54cdd8c9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d75a279e20ccd31095f2c42b59b84651c5ccb5a2327fdcf81b27abe160165480"
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