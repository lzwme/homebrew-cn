class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://ghfast.top/https://github.com/ForceCLI/force/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "f16d83baada55ddf89367b1e7d4f81499b77228fcb5bae5cd2046466b026ac09"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34672b5fc5e14f15e08debf3ca4ade97453a3bf61937b0faeb751b11ec3ab803"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34672b5fc5e14f15e08debf3ca4ade97453a3bf61937b0faeb751b11ec3ab803"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34672b5fc5e14f15e08debf3ca4ade97453a3bf61937b0faeb751b11ec3ab803"
    sha256 cellar: :any_skip_relocation, sonoma:        "09bf6700dce4cd480816ab359dee1ebe56cba611cd403bd81f50bd2bc8cbeebd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70eb37022e3f127c868f865fe4102bc310f7ce01379d5a5e10d873915952f341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5b8bea2b997f98a617466e243a6d0a9d895444bbb1c5f32cca126e1b0635065"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"force")

    generate_completions_from_executable(bin/"force", shell_parameter_format: :cobra)
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end