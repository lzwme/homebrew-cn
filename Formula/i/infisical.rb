class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.143.tar.gz"
  sha256 "871a6de0de483c394a3a9859cf4bab2898434ab443beb501ad1b045b3f0e4c40"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2e99ce07d66a7853f889c8c0ac1b1fb3247962f1c4afc67cd7361d8c1ad37a75"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2e99ce07d66a7853f889c8c0ac1b1fb3247962f1c4afc67cd7361d8c1ad37a75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2e99ce07d66a7853f889c8c0ac1b1fb3247962f1c4afc67cd7361d8c1ad37a75"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a4a96699818c326dcfebf7b2a5905148bc6a12e62e20e1fedec682641bd8b940"
    sha256 cellar: :any,                 x86_64_linux:      "a8df28d6cc57f24417290b17870e832c0e857887cacd619b3be302dedae178bf"
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