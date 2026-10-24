class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.44.9.tar.gz"
  sha256 "aef34aad2b67fda812707d7cac8b4951adfce20152eb882de4da99fbd6b51762"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "38c4c61218409b8195f1689a66d7f5217396a0dbbac80dfc493f7318a8d85872"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "38c4c61218409b8195f1689a66d7f5217396a0dbbac80dfc493f7318a8d85872"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "38c4c61218409b8195f1689a66d7f5217396a0dbbac80dfc493f7318a8d85872"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "494bd9f333718e3be0550b431fba05111a973553b59213e8828e02955c0a0a10"
    sha256 cellar: :any,                 x86_64_linux:      "400ac0500eed36cb4143b4b413d06ba83219bee99ba5953a7e82cbd8061615c4"
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