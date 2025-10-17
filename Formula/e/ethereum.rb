class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://ghfast.top/https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.16.5.tar.gz"
  sha256 "4a5f2a2af0e7463bd67483e2d07c7ebd95913a9335c3e67a42090dc722fed744"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2aee31cca88d26cb1ee5d8966d58a438917c455827aa461f6b1282237fec90ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7700cdf2a87da7e806407b915c3b38f4b15b5f9cc548f1990b0c4d454135c95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "840a2d039f0b143ae6c1a72ef40cd1488973ad2ab0bc3a79fa2e63daf41c1fec"
    sha256 cellar: :any_skip_relocation, sonoma:        "dff7f7309cdac5105f912ef288d6bcb4259c201b64b5e860d8cd13e66bd8898a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c94621f27690e775fafb820f4ee6d0b71cfc66483c6bfaf71b3aa7fcdac23ce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e196637d713f5ac6894f2b3982d48e40b911023a22e1913de926803e9b628dcc"
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