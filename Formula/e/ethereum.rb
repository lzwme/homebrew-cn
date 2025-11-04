class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://ghfast.top/https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.16.6.tar.gz"
  sha256 "b1adb5747cbe1f2a69d9cefa98f67cdbd851c6cd9008686f1fb66e7b78847f34"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "199534fe3da3de9777ec5b7d7b448cff892397e7b34f4fd60dcb152ffbac13dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0edbf9606a45a5abc790b1df7aae96451a95a93c9842baecd0873851850845e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45a840b3b697ca864361eed93e1d0796cfed8b437b34e872dbd0d6bda1f6ffff"
    sha256 cellar: :any_skip_relocation, sonoma:        "4491129177bcd22763097092e92176505779b06e22810af0bac352deaa5dfbe4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b656a9d96767364c54df92ba714fe5613792aeaa6b8f33fed518df7cbe9b5c74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b48c58c93c0d8305001ffd3449bba1d241d362faea65af5394ad5aa79f715fd"
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