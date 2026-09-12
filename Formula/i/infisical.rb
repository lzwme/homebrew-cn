class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.131.tar.gz"
  sha256 "18cb233f5f3d5611d39a70ae6203c89f6207920b3182b7fc7906db9578c04ab2"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2f83e546eeeab910b42218ca455c54dfc974092a264481936331581ecc864934"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2f83e546eeeab910b42218ca455c54dfc974092a264481936331581ecc864934"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2f83e546eeeab910b42218ca455c54dfc974092a264481936331581ecc864934"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0541a83cfdf839dd66651b14dda75f0e4b376eca5d7017322939baa26b40bd10"
    sha256 cellar: :any,                 x86_64_linux:      "0d5701cedfcf49a50ae206edb0786766f54791957b8b88768782ac66b6a56085"
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