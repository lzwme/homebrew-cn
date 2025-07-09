class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "9f0a15c07fd9724d202fa828e4292048960424e4ea6fa7a59ac7d854b46a8b91"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d68d7df258b50d9adfcca30bee5e2ad1c2e0a9076da4d61a8342d9d0cb837f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00b78abbb2c286704a39895ab97f39687ff701f39174ddafe40b41503678dd87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9fb9cc2da14d1c7300416451aba2461ad5a775204cbb1109e1731e3c22622f43"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a4396b3dd57f1d61a58e3b19f6cff6bddd987c463c3dce760edb141a9ca3728"
    sha256 cellar: :any_skip_relocation, ventura:       "aa678a1c53f66da939180a6db50a9d437c0ce39e17f61322217d84d6ae8b4e55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38431c56ad3af4c5845e3aa0f2cff315f1e810f7d3e978b502bd3ddc519485f4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end