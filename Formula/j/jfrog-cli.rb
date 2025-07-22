class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.78.0.tar.gz"
  sha256 "595a5927cea39facce3fee2b992a9d4021c3179fdfa6054e18e3de14950a403b"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "v2"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c76b807ff6aae89fa2ea4c8eb2d0e876bedfd7242bb5c73db19091c136e74b25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c76b807ff6aae89fa2ea4c8eb2d0e876bedfd7242bb5c73db19091c136e74b25"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c76b807ff6aae89fa2ea4c8eb2d0e876bedfd7242bb5c73db19091c136e74b25"
    sha256 cellar: :any_skip_relocation, sonoma:        "e846a7353193174e665602aa616d96eb546736abb7cadb051e517356281a2674"
    sha256 cellar: :any_skip_relocation, ventura:       "4c0e5b86b8aeb21731b1eee53a220bb69059bb0fac69cda3814121ce7a2bd288"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d758b9073f69ca5659d01320befc9aeed9b4ddd3edaa099c58c6f983e3630815"
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