class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://ghfast.top/https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.17.9.tar.gz"
  sha256 "dce5d109fb2a29a740cc41ed9e5b78e1e4a08af8bc0899baaf8797bef68aa591"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f2cf39bc669e8c1f477ec3a4f7ba3f05aba6bb0984e40b0c08d89f78e84af8a1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4aa65fbf630292af8a9fbb1b364c639d3d83fe16a39929673bad901a9bbeba92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "afe75fbf85dc7b74413f75407ba2765d9b0e1c2fb957781556ceec3f07ac335a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ce7fab05fe3d71e3a2b0fa68a759dc6c8cf5cfadd32c3e9febefe1afc9fbc7d5"
    sha256 cellar: :any,                 x86_64_linux:      "7f7bf0606f6ab3ae9ea29a21ad4db954f2da51ee95babc64b1fed9a7bc02b89a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Force superenv to use -O0 to fix "cgo-dwarf-inference:2:8: error:
    # enumerator value for '__cgo_enum__0' is not an integer constant".
    # See discussion in https://github.com/Homebrew/brew/issues/14763.
    ENV.O0 if OS.linux?

    ldflags = %W[
      -X github.com/ethereum/go-ethereum/internal/build/env.GitCommitFlag=#{tap.user}
      -X github.com/ethereum/go-ethereum/internal/build/env.GitTagFlag=v#{version}
      -X github.com/ethereum/go-ethereum/internal/build/env.BuildnumFlag=#{tap.user}
    ]
    (buildpath/"cmd").each_child(false) do |cmd|
      next if %w[keeper utils].include? cmd.basename.to_s

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