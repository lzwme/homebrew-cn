class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https:geth.ethereum.org"
  url "https:github.comethereumgo-ethereumarchiverefstagsv1.15.0.tar.gz"
  sha256 "b720c91aa6d721ba1f9ec753fa216b27880d0fdcb3204d0725d411d215507a13"
  license "LGPL-3.0-or-later"
  head "https:github.comethereumgo-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18ea2d65b0920a84220d0990f99bb1710476c6f47810e8baa2894429b5023f04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d21db4489b02089d028aa86b968174e9766ee72aadd84076033db575788d905b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b92cd7a8aec12ae55aaa429e13d87275a6e8e8fec8e74ce6d05f15c0d8c5a10a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1301eb97ce0bd81b4e4af5e0deb2c14544115dc5fb5546b1dcd980bbcaf44b6"
    sha256 cellar: :any_skip_relocation, ventura:       "318625ff790c0aa3a27adcee3ad9fe48daa6fd54ac6abc01d685ab4646dd3cf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5c5d3d6d76a20cd42d3fcdc6f2ce2e83347481ec188b40d7ceff00d32238fc0"
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
    assert_predicate testpath"testchaingethchaindata000002.log", :exist?
    assert_predicate testpath"testchaingethnodekey", :exist?
    assert_predicate testpath"testchaingethLOCK", :exist?
  end
end