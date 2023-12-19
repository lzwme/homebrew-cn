class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https:geth.ethereum.org"
  url "https:github.comethereumgo-ethereumarchiverefstagsv1.13.6.tar.gz"
  sha256 "fe17444db3110c9f7f0d34b286bd76c9ac43b84f4e36a6bfbccf18de815cd5e3"
  license "LGPL-3.0-or-later"
  head "https:github.comethereumgo-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14ba53da4b4b70da58e734c8b739e7cb9ee2e8869250a917e0b677a26b151eba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9033227f021037518f7b84712c14ea5d2375bb4689875ea82348d56735efc9b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9266b6348fd24572d58e4ac8300e51ff86614a79d425bf72a5babf916fac9be4"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7d642f2d5873a6b8f2c4d329f3452d26e8da4ba2b252e6b1078631f01ae4d52"
    sha256 cellar: :any_skip_relocation, ventura:        "21073c586485e16ea5db49def18bfafe36b193c7779dff9042602a15c1b54837"
    sha256 cellar: :any_skip_relocation, monterey:       "4129422018c3a2d153339d6597683d885c90af2ffb6daad3f0dedcacae37b370"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "511a2cc1734bac2473c050301ad38181bbd0e35ef9ab49bad60352fd1a8de729"
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