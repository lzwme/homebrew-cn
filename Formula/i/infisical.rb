class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.108.tar.gz"
  sha256 "f173855b4f8da5f645660adf205b118651148b90077d86aebde95e394ae27ed6"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55246a1a848db20e6e830815d7dac22aef41e48becb669a0063e5bba2ad55f3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55246a1a848db20e6e830815d7dac22aef41e48becb669a0063e5bba2ad55f3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55246a1a848db20e6e830815d7dac22aef41e48becb669a0063e5bba2ad55f3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5e3bd010776232aa4d1d9cd92e0c83e94051820ebea055cb5019767068f9c8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72dc7fa6090e885983d03c4cf715dce1fa126f01f1b0e5cbd9bdca31056b8ba8"
    sha256 cellar: :any,                 x86_64_linux:  "cd1e8b495add6c25c89abc4eddac5b8978742d896a24b738492966a820582ad1"
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