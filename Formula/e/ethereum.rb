class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://ghfast.top/https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.17.7.tar.gz"
  sha256 "1b2b0759240d70d959d43fd9d2f9df3fe48ed990f270bb5fd9f593f61ef3127b"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "14439eddfc9f8429cce9d83a06bbaeebab7af493e7640c4050b4a6566cbc5057"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d28ccf0a41b835a50b1f6acf7b3939e19d623a0a15091a3346808752685fcb6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "778ae881ad9b20b5efa484aceac58949c56c965cf39e9bc2ac47ddd0b6db1469"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "355f62d5d4457f9eb8c42eda363ee403ccaa4a2e13cc4aea4f695d9d7989aaad"
    sha256 cellar: :any,                 x86_64_linux:      "1059df6616ede06510d28f09b07e85ec7585ed3a12b3b90ee86c4a7a6c99fb8c"
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