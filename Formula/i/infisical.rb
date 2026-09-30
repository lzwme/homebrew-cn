class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.138.tar.gz"
  sha256 "259212f862eae480b667a190d9816dac34a205c421bf3700652f6f58cc7e5e74"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6fc0249c5e7fab58913b636de657578e0f8c358e5665b7903613d8c63f2cd6ab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6fc0249c5e7fab58913b636de657578e0f8c358e5665b7903613d8c63f2cd6ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6fc0249c5e7fab58913b636de657578e0f8c358e5665b7903613d8c63f2cd6ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4902bed9b16d6056e289e1494cf78270aa73d8bf34e16f64b0e62661aec12b4e"
    sha256 cellar: :any,                 x86_64_linux:      "95d68339504145b54eb5e8443eb5200b21bdb8f5ded9afad0631a0f92e204946"
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