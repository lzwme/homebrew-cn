class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.89.tar.gz"
  sha256 "e9d5e817557a90b2d5a2817be6af58348a5016ac1c904f1acac3c300bc661aec"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cc1c54ff101a4d003adda5bb5a028c5624e5b799e31fb62c3fee779be6793ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cc1c54ff101a4d003adda5bb5a028c5624e5b799e31fb62c3fee779be6793ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cc1c54ff101a4d003adda5bb5a028c5624e5b799e31fb62c3fee779be6793ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "484640710e9655528161fb8edb81ba1a670d1ed3c57abf0afd99889080d8cb74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05a8853756945f434ca9b163bba74594d7804b9caafe2474068af09ef8986156"
    sha256 cellar: :any,                 x86_64_linux:  "d627853480047982e7b1d7789e6c8858d30803d6cfd46d3742ef0c41658f04c3"
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