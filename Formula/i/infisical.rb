class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.49.tar.gz"
  sha256 "11ec2ad0ebea65bb2c49d457c8e9816dc16edc4b3635fb02167d580a3158ec45"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18d9696cacb29bde3a09f96960b3176a9e77980305a60feac12261c9a1381e02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18d9696cacb29bde3a09f96960b3176a9e77980305a60feac12261c9a1381e02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18d9696cacb29bde3a09f96960b3176a9e77980305a60feac12261c9a1381e02"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1302181f5866279bacec009e296631e05c9d179896a511b564cd9cb83c6fe24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "477a7c8ff7323f7068394ec7e1f40221e5d1718509eeb0a9f8c5ef4ac1bcef90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab0d7a2c7b7199de2c5efb14c0266c89df11b3cd3620c0441c3607a10ccdfc57"
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