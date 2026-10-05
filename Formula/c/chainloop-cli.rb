class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.115.0.tar.gz"
  sha256 "fc68fd39459eb45d2b6751797733fcd3a49d7cacf65dd3b02756e9443c399dea"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7ccdc329d2c396274b5734f86409d00e309213308d85fd94371b52260012ee53"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7ccdc329d2c396274b5734f86409d00e309213308d85fd94371b52260012ee53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7ccdc329d2c396274b5734f86409d00e309213308d85fd94371b52260012ee53"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "febffdd1c86fde6a364e85cfe7dab1aa76fbc95756afe8d41df363a126e9cbfb"
    sha256 cellar: :any,                 x86_64_linux:      "1a71236a80807594ac7a8b6e87a3bfd03064968d4395d69c717a155230c50309"
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