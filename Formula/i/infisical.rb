class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.32.tar.gz"
  sha256 "ca8f3d36952785e6345330510aacc47081aff0ac6da693070e22c371b5f45552"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40eda1933b3dd340d1d10c2c922130cfd84d1f0f36e1ed3c624969781230457e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40eda1933b3dd340d1d10c2c922130cfd84d1f0f36e1ed3c624969781230457e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40eda1933b3dd340d1d10c2c922130cfd84d1f0f36e1ed3c624969781230457e"
    sha256 cellar: :any_skip_relocation, sonoma:        "089dd8070c7ca2916a329ece75c813e137fe1311146305bbb05fae89d5092b61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff7c527cdf629e97351f70d5a276d7555381079144006df7fc2ad1d072a50133"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4c132cf08a44b8228d02cd7f91ad59ea538c525b953075cb3090f5fdd68ca72"
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