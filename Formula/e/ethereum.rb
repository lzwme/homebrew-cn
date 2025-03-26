class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https:geth.ethereum.org"
  url "https:github.comethereumgo-ethereumarchiverefstagsv1.15.6.tar.gz"
  sha256 "b5296151c8a3d07f571cb5691501d8c9c8987fa83d3f8c56396c62c83bb2e08f"
  license "LGPL-3.0-or-later"
  head "https:github.comethereumgo-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd4e55c690380a79831f46d18675a4058deca9bc6f260be4e2bf410a4c02e995"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65625a43dabda6c50d42fdb6370ebf3ea63fdfaf3d7608190c8f9f1423e0de67"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b66084ece0061b01b18a2d96711f569c32634e43cb73e6a90b3b801143c22908"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f3a38c22c1897216cc0763f17912ef9db495fe7829db6facf1692bbbba14441"
    sha256 cellar: :any_skip_relocation, ventura:       "a437fbe8b00bc52d1e1a877737ee05fc7ded4c2bc87682fc5d27ce2b1a712f16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "849270c3c3530c5aa2b8426837753c74f6bfaf5a2aedcac4bc6fa2d11d62c381"
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