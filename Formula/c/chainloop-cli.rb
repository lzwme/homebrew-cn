class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.114.0.tar.gz"
  sha256 "c84a38562b0d7a40d696cb05ca98c99c53397e6adfe0226a949fba27139720b2"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0476bb2c30f06c3a005d1fae07c8039f076b38e6042267424feecef4bc9dad59"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0476bb2c30f06c3a005d1fae07c8039f076b38e6042267424feecef4bc9dad59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0476bb2c30f06c3a005d1fae07c8039f076b38e6042267424feecef4bc9dad59"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d4c3549e8da7dbef355754d73e67a86cc4723ef7a4f2e2c11c4c6ec4992450f3"
    sha256 cellar: :any,                 x86_64_linux:      "56cec8db50b02118c2ea1c932be58ff3950c24e74e58eef617a21d7898b89cf2"
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