class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.38.tar.gz"
  sha256 "01ba75e2288eea27f3389449b69fcf8222e74f2e7b96bae2624e08b88d2c3125"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f3bc8e85fcbe4b288f446a30ed042e3597c5c5e6c694d71af3c0e17eb7dd446"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f3bc8e85fcbe4b288f446a30ed042e3597c5c5e6c694d71af3c0e17eb7dd446"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f3bc8e85fcbe4b288f446a30ed042e3597c5c5e6c694d71af3c0e17eb7dd446"
    sha256 cellar: :any_skip_relocation, sonoma:        "404c5cfe8ed154cd22352ead11daa25198de698bf8457fe55d628bc78e38142c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04af38bebc67fb3be4f5ea47ad55047507d08c7bbcd64dcd7e0a734116fbb3a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be3d193e500eebd3ffef929d7daa0b50de2fb1ee08f8107393d19d9b3cdd52b2"
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