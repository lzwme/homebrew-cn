class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "2cfbea3a85c9e90efdadabf4084317acedf4cd0c15f9f08d5119d3e49942bc99"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "08bb9da55b35fee51a6c61f4df84c119bfde336b51e62a3e68a1a48d19fbc2de"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "08bb9da55b35fee51a6c61f4df84c119bfde336b51e62a3e68a1a48d19fbc2de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "08bb9da55b35fee51a6c61f4df84c119bfde336b51e62a3e68a1a48d19fbc2de"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "66a190660b8a50207b0d26c251e218cc0a84c1df42e38d297aff8a6cdcd65551"
    sha256 cellar: :any,                 x86_64_linux:      "eaca9b115c68742e5f5b9f8fc13b9b14e92747502835d75fc81bcd64a8883163"
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