class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.42.0.tar.gz"
  sha256 "4e1430da08950cc8101e7030dbdd7eea0b60c1269156cabfd7de99e7b20d06a2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "220273eedba2612c6d31323a5d9e665b15fca2cd1766802be926c9d295105661"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "220273eedba2612c6d31323a5d9e665b15fca2cd1766802be926c9d295105661"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "220273eedba2612c6d31323a5d9e665b15fca2cd1766802be926c9d295105661"
    sha256 cellar: :any_skip_relocation, ventura:        "a43ec0e67be6d611095072e626ffd8a97eefb7f5b6bd84967d4cf4bda9558bb8"
    sha256 cellar: :any_skip_relocation, monterey:       "a43ec0e67be6d611095072e626ffd8a97eefb7f5b6bd84967d4cf4bda9558bb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "a43ec0e67be6d611095072e626ffd8a97eefb7f5b6bd84967d4cf4bda9558bb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3bdd143916e5c7ddae7b7cd5350edaa4a52070b14b43465ff8a3ef6ac1972bd"
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