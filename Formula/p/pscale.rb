class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.337.0.tar.gz"
  sha256 "e4933dfb55bd45627786d89334f5b68cdf56fb407e1b3f747992933fca78def8"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2805979dd49df82a317e1cea9a92d6e2d6f543c5b3ff3dc2c6bad2bba80f8cb2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4d747065aed847bbc5a23e3772fa5cca2922c80ec6e74b6a9ed7ac7e7264ca51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "55e93eb4e6357898dab2922b9cae5fb868594ddf817431bc43963f5db36d208d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a19b816bcb5201ea3ffc14e990b2cf3ed1cfbe9def770684641716ceb30a47a4"
    sha256 cellar: :any,                 x86_64_linux:      "8655856bf34e163b5d3a3642fd6ed6e477ba92133006d2af93d966b8b2607e35"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end