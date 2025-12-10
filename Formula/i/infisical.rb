class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.40.tar.gz"
  sha256 "9fc9b487cc4b1dface728512e66fd72e01dce83ee2652643a3bc1070eebc3a58"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d257d9a9ec2673959163f35122b8426fd427056f3ce1d59f755b064cf85d1343"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d257d9a9ec2673959163f35122b8426fd427056f3ce1d59f755b064cf85d1343"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d257d9a9ec2673959163f35122b8426fd427056f3ce1d59f755b064cf85d1343"
    sha256 cellar: :any_skip_relocation, sonoma:        "9079a2e0aafc8148ab5e596f0b42429fef2de8d3cf13d44cfe56003eac71ebc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e2f45d21d007f05ac9b4bcf19bf9e19650bde168a0d013e2155a86037655ca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca48c9c1bb4cb85c9cd04be7177cfcf81d4273cbddff1edd64345b73a7bff272"
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