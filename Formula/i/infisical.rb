class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.23.tar.gz"
  sha256 "001a4af6adfeca56112b64d025296d9137848ee32a5f3a93f04caa9a4248e8de"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d07555ba61e23e781002d0e0140542406683a26f7f853896caf4f10c9c58915"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d07555ba61e23e781002d0e0140542406683a26f7f853896caf4f10c9c58915"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d07555ba61e23e781002d0e0140542406683a26f7f853896caf4f10c9c58915"
    sha256 cellar: :any_skip_relocation, sonoma:        "314d3d53833cd1bbfc3e93ff36a9f76a058abdb51f03898217f191687fe6fc3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4adb15779e2dd493e309aa4b2c7be497682a280fbc2cf9d05845f3c0fa9b6e39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e706b2a5990a6b143dd661c874067b06cf3a378b8193e6e9b723dc9353a53a5"
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