class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.132.tar.gz"
  sha256 "44824c4291213be290318126076069670aa1e226e8989df29713ecd28707ea60"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f3fcf82285a6798a47da9fc802b7c77f18787a5e3aeec18f8e0fefd931a2540e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f3fcf82285a6798a47da9fc802b7c77f18787a5e3aeec18f8e0fefd931a2540e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f3fcf82285a6798a47da9fc802b7c77f18787a5e3aeec18f8e0fefd931a2540e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ade1cf3e75e0da395ef076c4e83b38b2b38097548bf1e960c87ce3361b909637"
    sha256 cellar: :any,                 x86_64_linux:      "59439e57d6318de08d7cded5fc5c6060521d372712db359047d40eb41b64f3cf"
  end

  depends_on "go" => :build

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