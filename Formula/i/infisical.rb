class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.58.tar.gz"
  sha256 "2d93f3976b6148b087ad4efd208a6d1eab8101139f6e0d71673cbb2230a6ca63"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c08406dbb9c3acb381f91fd04768fc94dbb9d7ea3148985c808dcc3aa1b5f3a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c08406dbb9c3acb381f91fd04768fc94dbb9d7ea3148985c808dcc3aa1b5f3a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c08406dbb9c3acb381f91fd04768fc94dbb9d7ea3148985c808dcc3aa1b5f3a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "744c4c1261eef78136f83aff720d5b2442721fc1c62ed2c2399ab83815289151"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff84b16a538f0c3b2f71e11eea9f42954eaab84e016526c5d14a50f4fada7eab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e70b66335df3b8c5cce2b2e342c4dfb703182466e2bde5a663eba53e914eaaa"
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