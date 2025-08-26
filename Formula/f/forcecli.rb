class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://ghfast.top/https://github.com/ForceCLI/force/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "fa7518c994a7b560bb2ba84e5120d0da202f1edf4848641620d86587f22138d5"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0a29203c31fc04d0db1e0e31b6f1cb6bc87ee38ddd08b16e28401695b141774"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0a29203c31fc04d0db1e0e31b6f1cb6bc87ee38ddd08b16e28401695b141774"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0a29203c31fc04d0db1e0e31b6f1cb6bc87ee38ddd08b16e28401695b141774"
    sha256 cellar: :any_skip_relocation, sonoma:        "d026a7b73bfc7fefed5fb736a80f7d3252727534585bc5e4b261064b6502e107"
    sha256 cellar: :any_skip_relocation, ventura:       "d026a7b73bfc7fefed5fb736a80f7d3252727534585bc5e4b261064b6502e107"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15fa0e67615a8ae3ab793e2cfa15f72a2b9d5b64d2213b5ac1598a7c17829444"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"force")

    generate_completions_from_executable(bin/"force", "completion")
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end