class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://ghfast.top/https://github.com/open-policy-agent/conftest/archive/refs/tags/v0.71.1.tar.gz"
  sha256 "1bf5a6ff4b9d7bd943b9713ace13c83c40b77fd3fcf2a9659f32be67c4a2c368"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a3e738e62088ae315606901c412cedb6ea148c34eef552289af31648859ef6ff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a3e738e62088ae315606901c412cedb6ea148c34eef552289af31648859ef6ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a3e738e62088ae315606901c412cedb6ea148c34eef552289af31648859ef6ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "597046efac10df441d73ea0069f22081ed87368de6709ed3b0b526f50c398b9f"
    sha256 cellar: :any,                 x86_64_linux:      "42b3df729c4f77787a89a26e9c066d8afb6eb6be5c4e3b7d5b013f780093f95d"
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