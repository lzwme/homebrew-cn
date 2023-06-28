class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.41.0.tar.gz"
  sha256 "bac901254a85bfced30db04b0b80851cf554d49ba1cd9819258fa0d4db893dfd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53cf06a52c500ae4c453b0a04de65e28626c749ac79f21ef211295ab4a682880"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53cf06a52c500ae4c453b0a04de65e28626c749ac79f21ef211295ab4a682880"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53cf06a52c500ae4c453b0a04de65e28626c749ac79f21ef211295ab4a682880"
    sha256 cellar: :any_skip_relocation, ventura:        "09a944597ac627dff3fe0e18da68c0bcae81fec001da8631c07c339acea55d2e"
    sha256 cellar: :any_skip_relocation, monterey:       "09a944597ac627dff3fe0e18da68c0bcae81fec001da8631c07c339acea55d2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "09a944597ac627dff3fe0e18da68c0bcae81fec001da8631c07c339acea55d2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23ad4423feb6fe0c194eab318e0db12530009f6945c20cab03a326dd9c129fd4"
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