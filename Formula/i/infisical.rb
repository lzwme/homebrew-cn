class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.73.tar.gz"
  sha256 "08d3bc3da0ef8d15d04a769956404a029805c227c7a24ae567cba4342f45e004"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "161d8ef5395d367b5215df0acc637480b1dcfbd57f93a5ee0162f77b2f626380"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "161d8ef5395d367b5215df0acc637480b1dcfbd57f93a5ee0162f77b2f626380"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "161d8ef5395d367b5215df0acc637480b1dcfbd57f93a5ee0162f77b2f626380"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcd38f6324fe1695ba280438a409d8636cebc33831b4635652568c5ada32c562"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d1040dac10aa3637ac91a60a8c4d664a15298434ca4eff4579aaf7bc32ec10f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e27bad061d13e73356d66251e282e12c6fa5ed11f67f3d486804cb095cd29df"
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