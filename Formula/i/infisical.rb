class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.59.tar.gz"
  sha256 "752749741c022bfd2ddc682757960e8ea8c619d90c92772e5561c86588027fee"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca4df0cbb5d777af61cca3fa7eef982174bc77ab70fb87aeb41ec2152cde8012"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca4df0cbb5d777af61cca3fa7eef982174bc77ab70fb87aeb41ec2152cde8012"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca4df0cbb5d777af61cca3fa7eef982174bc77ab70fb87aeb41ec2152cde8012"
    sha256 cellar: :any_skip_relocation, sonoma:        "60a57a98a03f25019b148f50c1415110093ebaba2c60ef1b8e3087b88c8b96f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b32bfc729138dbeae6f343ebea8276331f0c46bba81e03a3e9b7da42a6eb29e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c16d04e2d522db7120a847b6709f9d7ce7dc8010fd6cb6101ca00f01055683bc"
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