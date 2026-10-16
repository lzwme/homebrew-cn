class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.44.1.tar.gz"
  sha256 "643bbd7804e6d9d9da082419f16f74e4870487a86e217e9b8e44a25fabe13740"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c955f6bd1106f9ada596ab7557070abebb0acca1407f4270b99ba2cc122be34a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c955f6bd1106f9ada596ab7557070abebb0acca1407f4270b99ba2cc122be34a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c955f6bd1106f9ada596ab7557070abebb0acca1407f4270b99ba2cc122be34a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fae67bd5e9297fdea8e3d9c7ac29a8a1e8a7f129607c02836b2facdc7282f4c6"
    sha256 cellar: :any,                 x86_64_linux:      "9b1ec3eb72220d585dc7ca997ef3867f1cee884d0bb866e4bac9e6090c636c52"
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