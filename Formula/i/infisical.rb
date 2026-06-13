class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.93.tar.gz"
  sha256 "9f03d460d7fb24c8f7ff0852bffa371aa432d991c47e73f156983846d047c442"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "676e081f006ca4cec1d0a0eb5e518793129fc2c80288ac17259d265a93d4c11a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "676e081f006ca4cec1d0a0eb5e518793129fc2c80288ac17259d265a93d4c11a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "676e081f006ca4cec1d0a0eb5e518793129fc2c80288ac17259d265a93d4c11a"
    sha256 cellar: :any_skip_relocation, sonoma:        "58aecb5d3392f8d6c1a2cf27db3b60c960ece243d4913dd69b7db84aabd657a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbfcef63aae8eaca391a5665608b6b23ffb0be165196dff6f00f6a4ac73fa8e5"
    sha256 cellar: :any,                 x86_64_linux:  "81029b16a259346dd22a192a55aef8895cb4cb20d587a5f16b8696005f4c2e1c"
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