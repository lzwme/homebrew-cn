class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.46.1.tar.gz"
  sha256 "2d8a6931604d634fc9b7bc12b2ce7cb25b616e424b5ce7cf213049bfe186035c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e16e8055205917d483223cdecff9f8ad42a801f0cd8c84a2c1f93a73d22cad4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7f0ca9b99a24c6367988a6a37b7cbb0cd827238a711e1e8de0100add791c6d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "629c6764c9a0259d477ca2fc8933c595a2a71ad234a0b5c02bdc75070ed261ac"
    sha256 cellar: :any_skip_relocation, ventura:        "57095f80fc1309bf578d8637a200a4b182c5c9fd7608f612082fd721fdf93220"
    sha256 cellar: :any_skip_relocation, monterey:       "81929667060ed69de036ea7c98c063f1f03d6bd318acbd6848aa74e7ea7c3438"
    sha256 cellar: :any_skip_relocation, big_sur:        "cdde5c96899d6eb73e31a15dca3377dcfe805ff4ff55e8a49874a67827f618a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b64b20e948987a872b36b3d1a3d43ad7db633c0d3c87fc912bb58436f460db3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion", base_name: "jf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1 2>&1", 1)
    end
  end
end