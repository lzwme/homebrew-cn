class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.98.0.tar.gz"
  sha256 "1295a28f0b4d7b8a239e0fe74a24dab468385306a44ee7ff9e51fe824e2b00dc"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a019fec9222ad38c4be831d6004dcde8401101fef70640603d40bb5ccdf12ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a019fec9222ad38c4be831d6004dcde8401101fef70640603d40bb5ccdf12ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a019fec9222ad38c4be831d6004dcde8401101fef70640603d40bb5ccdf12ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c877e46e4ac0595931f1cd94ca628d8f6485ae1e332617af0396258e8d637ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "203eca387c4531f50147933e46f609d1ad076a53ac029f15852024defa08c849"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59769aeb5b85df98f4d5bfa7b12b0bfc5324e991de684641465a59a2d7cf50a3"
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