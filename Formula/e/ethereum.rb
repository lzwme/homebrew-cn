class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://ghfast.top/https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.16.2.tar.gz"
  sha256 "ab0650551a6f1d5443c6c857338f834c6adb5c96b1b2e4851e4b8cb516758ea2"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a098fc0d22c4ae595f297ee9b885f3123560bdd99cf4dc1ffbe17abb08cd5a8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53c6d76e84aadcd97cb04813752afb3f3dd3e7d7d266975ef4a98d033ec60a16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75fde0ed00a3f21bd10d1241f59eb93e0f95c2a1acae07e13dce93f8dd1113d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ec9b569c9192e01372adac46e2c780e5267e33973a64d437fa1b1cc0773a70b"
    sha256 cellar: :any_skip_relocation, ventura:       "f9d2c11ff615c0e6c7bea1eabd02d7a095f39def2db6c69a0c6424e081885000"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a787e1180747bb20e733c1d07b0bef2f8511d1738a060b07fad02a9f20d6dcfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c8bbb90be0f69983148366b2727b4fc299e638bd830024b36158eb07fbf559f"
  end

  depends_on "go" => :build

  def install
    # Force superenv to use -O0 to fix "cgo-dwarf-inference:2:8: error:
    # enumerator value for '__cgo_enum__0' is not an integer constant".
    # See discussion in https://github.com/Homebrew/brew/issues/14763.
    ENV.O0 if OS.linux?

    ldflags = %W[
      -s -w
      -X github.com/ethereum/go-ethereum/internal/build/env.GitCommitFlag=#{tap.user}
      -X github.com/ethereum/go-ethereum/internal/build/env.GitTagFlag=v#{version}
      -X github.com/ethereum/go-ethereum/internal/build/env.BuildnumFlag=#{tap.user}
    ]
    (buildpath/"cmd").each_child(false) do |cmd|
      next if cmd.basename.to_s == "utils"

      system "go", "build", *std_go_args(ldflags:, output: bin/cmd), "./cmd/#{cmd}"
    end
  end

  test do
    (testpath/"genesis.json").write <<~JSON
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

    system bin/"geth", "--datadir", "testchain", "init", "genesis.json"
    assert_path_exists testpath/"testchain/geth/chaindata/000002.log"
    assert_path_exists testpath/"testchain/geth/nodekey"
    assert_path_exists testpath/"testchain/geth/LOCK"
  end
end