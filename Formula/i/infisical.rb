class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.136.tar.gz"
  sha256 "5864fe63d1f6da1b1645d6bc0641cf5cf0f1bafc7906bc3347a963d8c2e6f8c6"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6cd6815272b3a6ef35ef58c1f286dbce5e7f05e42237218fd690d420a6a7eb36"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6cd6815272b3a6ef35ef58c1f286dbce5e7f05e42237218fd690d420a6a7eb36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6cd6815272b3a6ef35ef58c1f286dbce5e7f05e42237218fd690d420a6a7eb36"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dff05f6cd2cdb3097f0f0559442698247bee8147ea056eb327fc74566c489aee"
    sha256 cellar: :any,                 x86_64_linux:      "ed65d1a2c1c44fd0029e69cc5a6a071712560f43691dbd2d8b7380009a5a213b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}]
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