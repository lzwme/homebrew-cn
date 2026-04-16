class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.75.tar.gz"
  sha256 "5f1d997be25524c765b15aa2564d92ac4d7fbfc55888f9a6377ec4326195660d"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42c0890a1371528c07000492426a06292048dc6b7eac27d522ef1fc953e67774"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42c0890a1371528c07000492426a06292048dc6b7eac27d522ef1fc953e67774"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42c0890a1371528c07000492426a06292048dc6b7eac27d522ef1fc953e67774"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cfca9db69e4c2dc3d87621ea5d4a31724bacf2ebcce9a74507aa18b3f402778"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de3f27e2199f72af1766d785b020f805f93997d362682f4aac666e9cd5510add"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14ccb031c9a8f3e043fca4a145c5b7ae26d9a1fc695dd198585f70c734de4976"
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