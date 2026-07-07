class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.102.tar.gz"
  sha256 "55ab5d504746e166e939590e97619d52b59d5a311ce5b5ab33d6210d254f8c89"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "904e6f0397d76d6b570b03f47086fc5bffca08d6d70203aa5e5a7e3e4bbc9874"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "904e6f0397d76d6b570b03f47086fc5bffca08d6d70203aa5e5a7e3e4bbc9874"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "904e6f0397d76d6b570b03f47086fc5bffca08d6d70203aa5e5a7e3e4bbc9874"
    sha256 cellar: :any_skip_relocation, sonoma:        "433c8dc273f7cdc7f518386a65fcc00902391049cdd24a7de35fd7e63cd43515"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9c973f6b259e0ac0df2dde02c33367803793b883863455e20c15876df901755"
    sha256 cellar: :any,                 x86_64_linux:  "70751c3c98d7acf1bf184b5b73cb6c01e5a326e922d278f055bd2a20d6b001f6"
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