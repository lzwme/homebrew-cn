class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.66.tar.gz"
  sha256 "7a11d91b10de1b238e98a829e04906bd11d02cdcafbcc4793ebe152cc290609c"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4cacd27560990e08a5ad0b8b528347a1583017e2d7525c649a35ce4daa05c8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4cacd27560990e08a5ad0b8b528347a1583017e2d7525c649a35ce4daa05c8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4cacd27560990e08a5ad0b8b528347a1583017e2d7525c649a35ce4daa05c8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "747757babc98873e4660a434053f9b6989a0af4bf02252381fe6efaf3968b62e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1aad2b43b4c19d3fcd015d3b3234b1a8908d3f3e0ffe941279f27cc5327cdf34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8ea8721a27608f6b53d20a3102ad168027adae38e0afe1e02fed018bacf1b63"
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