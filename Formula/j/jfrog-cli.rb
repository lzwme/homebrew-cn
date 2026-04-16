class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.100.0.tar.gz"
  sha256 "44a01d798d50784fa115b1dd3151f90ab4683435edf270fb402f51bdd10fa731"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "213d62985dca0aa064608ac9524dba86c28976f1cbfc090c8a0ee36daadddd50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "213d62985dca0aa064608ac9524dba86c28976f1cbfc090c8a0ee36daadddd50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "213d62985dca0aa064608ac9524dba86c28976f1cbfc090c8a0ee36daadddd50"
    sha256 cellar: :any_skip_relocation, sonoma:        "7270e7f57012854e7afb8d589bf02720bac0c2d088dccd10cc0e1f87f90e0967"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b91cbac6a43359567ef14c44941ce34b969376009899955541476f6a660e1c61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "144fe133837b94da495188e839a77be3131186b70b9ab31e1fb909ebe4921fb4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion")
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