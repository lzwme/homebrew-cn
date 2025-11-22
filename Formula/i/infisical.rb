class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.29.tar.gz"
  sha256 "b4ac422e3ee4f35c8d2eceffd6753dada8031e740c1549efe46b1de0e3459bd1"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe5c5e458e7110dbcb33f3b69f21b3d3d276df46f391b1bb7761413ea20a7332"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe5c5e458e7110dbcb33f3b69f21b3d3d276df46f391b1bb7761413ea20a7332"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe5c5e458e7110dbcb33f3b69f21b3d3d276df46f391b1bb7761413ea20a7332"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc4590053f97ac0f84469979248b1fd4657ab0407c8dad28e1ed8feb5481f0b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f64989a271abae82f564eba51cb1b23d61fc02f1a279f4f59dab4f2d58674d38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9b51046c0e45db48b1599eb41b31a61844fcc9eee8f0ba5b7372b6c471300eb"
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