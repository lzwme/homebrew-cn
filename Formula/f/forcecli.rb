class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://ghfast.top/https://github.com/ForceCLI/force/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "0465ea28cf5834d5c534309cc2d31dc02be880e02154551539eecf6cc121dff2"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c546c3cc1cfa95fdfaa184477858031e9334a1fb6e179226433c3d9dd873181d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c546c3cc1cfa95fdfaa184477858031e9334a1fb6e179226433c3d9dd873181d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c546c3cc1cfa95fdfaa184477858031e9334a1fb6e179226433c3d9dd873181d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5df88404103fde0dd37e51a5a46aff53f2096bbb4c513bc60e4b0bb698bf9da"
    sha256 cellar: :any_skip_relocation, ventura:       "e5df88404103fde0dd37e51a5a46aff53f2096bbb4c513bc60e4b0bb698bf9da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc49ebf52c779b2631af94ffe7e9e7671bf883ef97709160cca0ac8f06e69be8"
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