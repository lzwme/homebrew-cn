class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https:geth.ethereum.org"
  url "https:github.comethereumgo-ethereumarchiverefstagsv1.13.7.tar.gz"
  sha256 "8cb25a4b189ca3e33664ab21849d8f254f9e2abfe9674eee7e6bb7d600713aaf"
  license "LGPL-3.0-or-later"
  head "https:github.comethereumgo-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c843434ef25dc0850d91be12986b79dc7befcc9bd8921234192efe92505ca46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79c9045ec161aac20f42564f9c51413195fc51c065df2dd2e5374d61e6ae5840"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "270140d5ca7ef1a2d9be2fcc30d01f9dde7fad44066cf9fca5d23bbfd77313d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d6bd9a753602b99c6b19da337c45a7170173ad6e7437939b753c08e0e10c1f4"
    sha256 cellar: :any_skip_relocation, ventura:        "8e38cce527e527a0458433afaeb14f5fe6138973c6f5072984dee4ce3c470ddf"
    sha256 cellar: :any_skip_relocation, monterey:       "a68b9755c19d21d8069dd7f631786466e31b8868755d5bbeb66f5bb093d0439d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5143efe0089b31765fa9c033fd0805d2ea85393e0cba3180706e0849376c749b"
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