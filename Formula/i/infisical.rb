class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.44.6.tar.gz"
  sha256 "088a41b30a47b8669cc1f055f2f1391614786ac25bdeed3fae90db654f42652b"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "99f078b153539c76b6d3495ca8a22b9bd1569f9a2e958ca3011b0dceff4fc650"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "99f078b153539c76b6d3495ca8a22b9bd1569f9a2e958ca3011b0dceff4fc650"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "99f078b153539c76b6d3495ca8a22b9bd1569f9a2e958ca3011b0dceff4fc650"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bb5a6714086dbc276f600cd7bec531c1fdc26c120c8276dcc08fdfb7bbc8b6a8"
    sha256 cellar: :any,                 x86_64_linux:      "03b20755cb5dd20d379b3d4052591086ba2a24814669b9b5a1c3758b71c189d8"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"infisical", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end