class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https:geth.ethereum.org"
  url "https:github.comethereumgo-ethereumarchiverefstagsv1.14.2.tar.gz"
  sha256 "bcae56e03dd1ea792cec4544c813b57c2d6bf64148378cc8c1499ead4fd1c268"
  license "LGPL-3.0-or-later"
  head "https:github.comethereumgo-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b157a6c6a245f4c6b5cf378581d284aec34f1e751f581c3b0906bfda950c7f01"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e08a23cf250b607ec2f39783d81d205c8de7404df26deca7ec351856e0e878fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a59a1619e484e0119ad740d11671a9d7a0248776016465e76ad51d9f730896e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d8ea3e540835980b5ebce86f112615bb4c328a9a8c628537170d3f47af37b78"
    sha256 cellar: :any_skip_relocation, ventura:        "9d2f6c05d14076912f9f6711cf630db32746eaaeaefb748e1092cf6a5dbdd444"
    sha256 cellar: :any_skip_relocation, monterey:       "174fba47f491f00388be40005708541c3c6c2568356b8f588e2ed996a1a14e0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c6ea6cec22988229735c299ffc7e63cc1957b8bbfaf3d63eeee099ee21db46c"
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