class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://ghfast.top/https://github.com/ForceCLI/force/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "ab18da754998347ce4f81145fe2bca422ce29a6c0fee6240da9ef3316ad35aba"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fad1be0d3cfa5010767a85d058778eee4893e00af2edba56a1981e278ec2ab0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fad1be0d3cfa5010767a85d058778eee4893e00af2edba56a1981e278ec2ab0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6fad1be0d3cfa5010767a85d058778eee4893e00af2edba56a1981e278ec2ab0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0379be9222c90af0a0c7270d5f424929a273e149378a13c4918004529cf7d34"
    sha256 cellar: :any_skip_relocation, ventura:       "a0379be9222c90af0a0c7270d5f424929a273e149378a13c4918004529cf7d34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e7ee40e2ee2b90b70897c309778cd6984df8330b95a92df43f48506f7ff375c"
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