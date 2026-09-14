class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://ghfast.top/https://github.com/open-policy-agent/conftest/archive/refs/tags/v0.70.0.tar.gz"
  sha256 "cf491b8e398895a8e0dbec76486defab65d4ad9723b9a19af159c89f63676da5"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c57ea4f1be9ec070ce16e6fc94a80bda74a299493714c894419a06b020ee8752"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c57ea4f1be9ec070ce16e6fc94a80bda74a299493714c894419a06b020ee8752"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c57ea4f1be9ec070ce16e6fc94a80bda74a299493714c894419a06b020ee8752"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "72536bc01fbf3ed6ae30ec4c29d56f9c38cd6b7585dd2e20d945c1ef05388883"
    sha256 cellar: :any,                 x86_64_linux:      "ca9587211b74069a6725e1457f7e07ced004e99502a0cf20f7b24fb3852b02ac"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/open-policy-agent/conftest/internal/commands.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"conftest", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system bin/"conftest", "verify", "-p", "test.rego"
  end
end