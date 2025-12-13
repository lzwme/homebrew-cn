class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.45.tar.gz"
  sha256 "773c289ad3e40d9a79371e872f85dba12bdfdcca262fe966c8fdd3ccbdf69db3"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45fe3bd4c30e86501ada2229c4190e98a4978bc0967e3629f0cd2601c406a8ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45fe3bd4c30e86501ada2229c4190e98a4978bc0967e3629f0cd2601c406a8ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45fe3bd4c30e86501ada2229c4190e98a4978bc0967e3629f0cd2601c406a8ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "00bfbefb7ec405063233cc50950f2e73f29dcd0376269ce322e1609ed8782c15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2891ac6b4c3be2e55387aaef3d1f8d7d9b0799be2e0e1a824d8fe6d66b960338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5c94dff40508383850e1ee45a390ed156df2c09eb7bdf319e5c1d1a800179d2"
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