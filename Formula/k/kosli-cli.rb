class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.47.0.tar.gz"
  sha256 "1c034054a26e7d4746593c9a2f233224b92661fcdf8b2bc1a5e6a1be23011bab"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b72042bab65d141cb64e280b66d2b756e05ee4365e530a1d97cd698944fd3ed5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "43b6f23944344dd0d4cf7f063cfc60d4dc5f94191ff8150d5079cd7bdade4309"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ce058dea1a1211883c771ce936e897e521c98e52fd237996385a73fdb59d0d2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3828d6320a84e5fa0e86948bb18c6ec1140db8ab5476371acd58206ba03438a9"
    sha256 cellar: :any,                 x86_64_linux:      "c6d9727893fde3f062ac861d79b6e8a4dc9be39e2e2bb48059c1da89173aa702"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end