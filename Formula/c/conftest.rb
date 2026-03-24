class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://ghfast.top/https://github.com/open-policy-agent/conftest/archive/refs/tags/v0.67.1.tar.gz"
  sha256 "2471242bcf6686a376e80616bdd972f2f3093dbe5dc52d61c2c9d19f366646f6"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d788fd0d4d81db107141dd65864ede6f75edb53796eb0b7a6a4a3b0b9feedeb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d788fd0d4d81db107141dd65864ede6f75edb53796eb0b7a6a4a3b0b9feedeb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d788fd0d4d81db107141dd65864ede6f75edb53796eb0b7a6a4a3b0b9feedeb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a600f10a0d81a7d8dfb8135adac17e3d62c45d6714d0a7277afdd7ec27e68c85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1e38912c38581df42d7a6690f445ed5312212ca821d76be351a5251cd2268e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f722203bad99d3adec2872d0496e29bab25d36ea7277bd4f245d44bf0268f55"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/open-policy-agent/conftest/internal/commands.version=#{version}"
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