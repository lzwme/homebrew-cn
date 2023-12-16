class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.52.3.tar.gz"
  sha256 "7f6b1c21d700192f96895dfd97e09026989d94cf47b93b9ed8bb0b88aee37410"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad8c7e99ccb1f96644e80c974a501b50923638f460cb1a76ce6e78e527c4bab6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07ffa76e4559eefcb44e57561304ed371facc44e5da470bb681c580370fab583"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9a448dacba52d0720ba7f79ca5375336ebbe4fe1b20ab17ce0406f4e12f168f"
    sha256 cellar: :any_skip_relocation, sonoma:         "927757cc0852daf556c3c53d835b4ba9c7b7b779b106a744a5664fa1ec7ab28e"
    sha256 cellar: :any_skip_relocation, ventura:        "9d640d8ca7b7fbbe4b0bc0ce895c08dd1b2163d627139ae1681e322538107534"
    sha256 cellar: :any_skip_relocation, monterey:       "e66ec7a97276b931e6c20ea65e8d7873b68806ab27660d73a5620da07931d00e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0191b4d15d6423a76e27c9f6763e59ad9213e0d37c713db9ea41c48d745fd243"
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