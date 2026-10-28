class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.44.10.tar.gz"
  sha256 "82483be14b7160001543a6f40277ff127bdd75f72f45f6e125a8a5e5f274a6cf"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2f06e7131815f7b0240c8816a6fb4250b1bbdbb9693b0d8bbd95defd769f1659"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2f06e7131815f7b0240c8816a6fb4250b1bbdbb9693b0d8bbd95defd769f1659"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2f06e7131815f7b0240c8816a6fb4250b1bbdbb9693b0d8bbd95defd769f1659"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a9f95f260d72734dc7ce77a0d12e89fab728c26a63feb36fb2f63f3627adaa7c"
    sha256 cellar: :any,                 x86_64_linux:      "03e7ed17c5d94ddc668b83c4df028fbf66e18a4eb9cec17a5824b71838b68072"
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