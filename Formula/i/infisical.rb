class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.145.tar.gz"
  sha256 "0b4cb6c2cec6c72467c67b263fd15a6ad430d9c1d845f028560aa62d7648958d"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "443555c8d205a9c0b9b0fb188b468fbcd0af8fce2b2a7c9321c573859e9dbb59"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "443555c8d205a9c0b9b0fb188b468fbcd0af8fce2b2a7c9321c573859e9dbb59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "443555c8d205a9c0b9b0fb188b468fbcd0af8fce2b2a7c9321c573859e9dbb59"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "867527bd6838f8cb3bc815315573f036cc959daa72fc2ac3e414cc49bdcc4ee2"
    sha256 cellar: :any,                 x86_64_linux:      "9c20f59b669e7499e4903d52e5d9e9997662473abfefe79bbc26f42243208a26"
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