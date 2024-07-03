class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https:geth.ethereum.org"
  url "https:github.comethereumgo-ethereumarchiverefstagsv1.14.6.tar.gz"
  sha256 "90494d9467d6e9ee44a171e9803ec5caace52bcbde8a808c945973bdcd79647a"
  license "LGPL-3.0-or-later"
  head "https:github.comethereumgo-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f91237db13709f4d44051ea9b91947acb104735e7580daa591edb648f95c6611"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8abc1383f07dc57721a7dc8e5ded9139a711542fdc9c51153d5bb7b320e18123"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec93056ac27ace74987253739d69614ddafccb3dc42c78a6dc5f8e5e23229868"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2e280fdb7bb8ae40e91075821ea6cde15f2ff919c18324e27f4abc5bfff1610"
    sha256 cellar: :any_skip_relocation, ventura:        "8a6ff8fae8a6a29f5c3de04188bd1b582d3ec2a28d6ce30bb922e67663ab3d11"
    sha256 cellar: :any_skip_relocation, monterey:       "3ea73a470a16a9d5c10d26dbfbd9c70f35a035894b6f204ff0b89c70957eda84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3cd98d73a92376db4fc386e035e592edc11f9f866ae5b78fd0038ab8db4dcae"
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