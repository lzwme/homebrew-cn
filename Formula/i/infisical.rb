class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.12.tar.gz"
  sha256 "665c5b993d86cc2d04aac5ef3c72b3eef8381ab4e5b47f469c5446b007a190bb"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1e3c4d73d7496b7cd77a856ffdf8ca7d9a65447be9883c2b87667ebf319694a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1e3c4d73d7496b7cd77a856ffdf8ca7d9a65447be9883c2b87667ebf319694a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1e3c4d73d7496b7cd77a856ffdf8ca7d9a65447be9883c2b87667ebf319694a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d0b118202d74f274f3261e5af183ecf7571fb7b70fb4a9397a9b0cdb325a150"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87b936cd6efab311301267ad65520dd7a0ed2a56b0660579c680e252af6328c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b469d84d78d0a911d2a30ba5b8cae6589efc2ffc8b2c932ff3247cf57c4d3ef4"
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