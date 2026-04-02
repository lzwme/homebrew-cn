class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.68.tar.gz"
  sha256 "3c842404a890111b927607936c4bf154f3aa1dbe8dc62c188fc817904165b87d"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb24afc78465e8d8914659adfdc306ca27dc9b7382e29edca0248c5137c3a421"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb24afc78465e8d8914659adfdc306ca27dc9b7382e29edca0248c5137c3a421"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb24afc78465e8d8914659adfdc306ca27dc9b7382e29edca0248c5137c3a421"
    sha256 cellar: :any_skip_relocation, sonoma:        "658d5664f7b4c702c7f2df135db93f51e3ce606c58b636c37765a210f1bc6c60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f6b578d9c44e1a31f19c1a58246ee54349e7dd4b5f7f58faf6b5d7cce8468c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d766e598e3c2710555dd0dd13118e47dc4a86623065725d22022aad389ddf45"
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