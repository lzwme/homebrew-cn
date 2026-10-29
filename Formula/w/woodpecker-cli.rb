class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://ghfast.top/https://github.com/woodpecker-ci/woodpecker/releases/download/v3.20.0/woodpecker-src.tar.gz"
  sha256 "c68b9692e7df7774a86ea37eba4eb65334ccc4c0526e3af050c5ec7b707cd78b"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e4ecb442afccefcb7fd3a9cdb0c03b5c82db5fa22bc2eff69608bd2920fb1c2e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e4ecb442afccefcb7fd3a9cdb0c03b5c82db5fa22bc2eff69608bd2920fb1c2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e4ecb442afccefcb7fd3a9cdb0c03b5c82db5fa22bc2eff69608bd2920fb1c2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "47d74380f0e4d50b14feea6e33464a69bba99c3a707026b87e46f7a40d8f8f07"
    sha256 cellar: :any,                 x86_64_linux:      "8c3d510db180167fa5d7cf16c0c64736431868a637c56eb564875c17605161e6"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    ldflags = "-X go.woodpecker-ci.org/woodpecker/v#{version.major}/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"
    generate_completions_from_executable(bin/"woodpecker-cli", "completion")
    # woodpecker-cli expects "pwsh", not "powershell" so we use the custom shell_parameter_format
    (pwsh_completion/"woodpecker-cli").write Utils.safe_popen_read(
      { "SHELL" => "pwsh" }, bin/"woodpecker-cli", "completion", "pwsh"
    )
  end

  test do
    output = shell_output("#{bin}/woodpecker-cli info 2>&1", 1)
    assert_match "woodpecker-cli is not set up", output

    output = shell_output("#{bin}/woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}/woodpecker-cli --version")
  end
end