class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.34.tar.gz"
  sha256 "8f4782c5038d0e7ec95408bdc74aef5227b8edce6de0efdec634871d2fe9966e"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "336b8c45de41cf34a048595af303b66b21774036ddc7831dce78ae510bb27061"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "336b8c45de41cf34a048595af303b66b21774036ddc7831dce78ae510bb27061"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "336b8c45de41cf34a048595af303b66b21774036ddc7831dce78ae510bb27061"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8a5afc85216a31051de095150b75d7c93055727a29cd9632fe70d63edf84f73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d2136a9c2b0dab6e8e0f8722a04b7943d98cd3a54f3666fa52551bdc910e220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3a4241aa08702bbaa50ed70b315423c5cc7d072cfcb03726b10192aba1ef3da"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end