class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.134.tar.gz"
  sha256 "27bb7d4260977b9a88c386709e9e0a4d25ca163da0f558e219a854f5d8b512db"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "765c0b7a9c0f948597a2f8c8e426fa63c234755404ff8b4f2e623391648c1275"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "765c0b7a9c0f948597a2f8c8e426fa63c234755404ff8b4f2e623391648c1275"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "765c0b7a9c0f948597a2f8c8e426fa63c234755404ff8b4f2e623391648c1275"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "56583d7105fe171bd2ad657b63e8cdbda1209ac5efac7b851f6b7c651a5f2672"
    sha256 cellar: :any,                 x86_64_linux:      "959095bac0bcf033d027b74fc9ebbb7b1ced1d89982ebff891e0227abeb7d021"
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