class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.137.tar.gz"
  sha256 "5f73bb41f28193d2ead172ec5ef38d1a9228732d13ab19124f14329a342dd640"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9ad4423e6feebcc316132c1aa8c3584ecc5a1e27fb4f09636cf6330f6dbbbcba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9ad4423e6feebcc316132c1aa8c3584ecc5a1e27fb4f09636cf6330f6dbbbcba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9ad4423e6feebcc316132c1aa8c3584ecc5a1e27fb4f09636cf6330f6dbbbcba"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "30ce30140d22984abf76477f52a887986a4739c080cf742913d6f7c92bd86f70"
    sha256 cellar: :any,                 x86_64_linux:      "e29759fd234f93185484b9fb7d24437228d09fabb61af625a753d46d7c9cd910"
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