class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.46.1.tar.gz"
  sha256 "2ab14b59efdb2b40494e855bd57a72adae5023fc970e55f04e1566eb60978be3"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "522452489b8d128f54629795d3bfa10a96a0aec1886fec39b3b95b4caa42242b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fee58583f3dc249ff9f4096aee522d6fe15b935be91da641e6c5c78c7218eaaf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a618c9954a903719b89562356c83a4b7cef04e0b65cb11b73bded2df17ed5205"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b7c36ead68a0b889a0e10d2d84bed511ec2b8218313c72231ed527ce09551ab9"
    sha256 cellar: :any,                 x86_64_linux:      "35654f586a31cb15dedbc7222566537416feae3ace0f2f598036c2c1da99f7d1"
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