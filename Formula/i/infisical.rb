class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.61.tar.gz"
  sha256 "b506c75407f21ffd914e78439cc8adb5c6da544d48c46f9d407849b7e467ef68"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70a33ffbdfda5ecdd748cdcf7e9c31032fddae74442b6366a53307b27ac9ae91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70a33ffbdfda5ecdd748cdcf7e9c31032fddae74442b6366a53307b27ac9ae91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70a33ffbdfda5ecdd748cdcf7e9c31032fddae74442b6366a53307b27ac9ae91"
    sha256 cellar: :any_skip_relocation, sonoma:        "111633a467d1041e284a31c021b9f758ff9bfcfea3a2dfa18b0c3290feaf83b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "631f64950df123d528ece232508aae0da47344fc081134a86fc8cf6320ad35e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b66b9b0a3eaaf158699d917e10d80b018ad8c123a0f999e381d2ae6bd3ef932"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
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