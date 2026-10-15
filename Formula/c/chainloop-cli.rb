class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.123.0.tar.gz"
  sha256 "d812ace5c12ff1c8bf0326c16912f124fb2fc59b0e330def1089e573b5fb2c40"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4511b145be17c43d62688ef0b89e33627cb76f56c3c73ecc44b0274f417d1851"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4511b145be17c43d62688ef0b89e33627cb76f56c3c73ecc44b0274f417d1851"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4511b145be17c43d62688ef0b89e33627cb76f56c3c73ecc44b0274f417d1851"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6f5f17b755adea898cd56395cb7f31cb293801d01fed898039f5dc23a9c5e6a3"
    sha256 cellar: :any,                 x86_64_linux:      "dc73570f6b6e05f660b149e79a64c6b15eff89b777c25ff5259cc79936892f65"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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