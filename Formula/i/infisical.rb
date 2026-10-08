class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.140.tar.gz"
  sha256 "21b1ee44465b59b11f1ba016bd90366f2a8959c2c46a40ba1b7ea2e3b3088a46"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6f426e6328258a46a62116964fbbad6e82358a6456e05ad8a209c43aabcaf9cc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6f426e6328258a46a62116964fbbad6e82358a6456e05ad8a209c43aabcaf9cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6f426e6328258a46a62116964fbbad6e82358a6456e05ad8a209c43aabcaf9cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "10a86d51b892b7cdee3738ddd4dc5c0ae8ba8a07cdcdd682db013ddf9652a442"
    sha256 cellar: :any,                 x86_64_linux:      "2cea215c4536a99a7a7ba096078eef0d6f71a7161e81fa69e0c9e8d139ef88f0"
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