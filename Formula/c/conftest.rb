class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://ghfast.top/https://github.com/open-policy-agent/conftest/archive/refs/tags/v0.71.0.tar.gz"
  sha256 "c881be645a6295a6a5bb7d85e5d45f9f157d810c82d7c0a230072b1ab8df7b6a"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b491ccb16086dcc8993663a7f861b143552f9487bdfd9f8d05b703c6314e3197"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b491ccb16086dcc8993663a7f861b143552f9487bdfd9f8d05b703c6314e3197"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b491ccb16086dcc8993663a7f861b143552f9487bdfd9f8d05b703c6314e3197"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e6c643bf9ae40a383711f9470d6d30e7c0e5d788434b39006701315fe98c8d5c"
    sha256 cellar: :any,                 x86_64_linux:      "57c9de891ce33978d231c9b70048e5b1013806c6a6a8f3a0ca5faef09b2611ad"
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