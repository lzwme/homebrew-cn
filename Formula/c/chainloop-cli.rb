class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.97.0.tar.gz"
  sha256 "b70c3d50bb42f271613b15cea75063d649f303ec9c36862cbbf28cfccbd01401"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37916180a9df4452c4c8fd91276489958f7302329d564c9402755a0e684f1337"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b76153bcfa200dc64d337cd90c2fb83df7130bbba261430cca9c1eb30daeebff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d170bef0a93fa83f4cdb3a4d1ef17cdd85571610686d7ad55e2ca83695af06c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b05858bfea78bc300b1cc70aab0484fbf35999c9fbb59de32b3c1fe0a2f368b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1db1d516e5533c69dd72ba60eb54c5d5107252b6581d021c93223f372f25c88c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b6cae2fd8a113205a958af49a95d4b8d4af7d261ec286ed58c8d84fe3530c33"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "chainloop auth login", output
  end
end