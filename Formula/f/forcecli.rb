class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://ghfast.top/https://github.com/ForceCLI/force/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "333fed2b751926c7f8ae6be5c7f6c3d86d2d7856e66fccb34f8d21866cc82bf9"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b195becb43ec5474b87f698f7e701597f9856ca6c9f75202ba2ff1eff397f40e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b195becb43ec5474b87f698f7e701597f9856ca6c9f75202ba2ff1eff397f40e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b195becb43ec5474b87f698f7e701597f9856ca6c9f75202ba2ff1eff397f40e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "aa6a8731637c205ba67ff9ac0e0aff6d85e67ca025b059eb5823e03856855334"
    sha256 cellar: :any,                 x86_64_linux:      "d0b5b8cb3a2d8fd9d6e615fac8e4d19adbb0a0850014cdba9fdc5b205d1e0822"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"force")

    generate_completions_from_executable(bin/"force", shell_parameter_format: :cobra)
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end