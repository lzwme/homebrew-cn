class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.108.0.tar.gz"
  sha256 "84aa3635e9fa0653c1462382e242cd92d7565a3ef3019d3cc8015939d5fa34e4"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "823baf2e5571c3f9e39ef150f89385d08d325bf2c0404fb3c2f9ee4edf677587"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "823baf2e5571c3f9e39ef150f89385d08d325bf2c0404fb3c2f9ee4edf677587"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "823baf2e5571c3f9e39ef150f89385d08d325bf2c0404fb3c2f9ee4edf677587"
    sha256 cellar: :any_skip_relocation, sonoma:        "7930dc29a2f779301a4c3c0eb8620db8b7f7494d7b61431692b862ee8f254940"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "149f6f6cbbf15fc15407c9ba8c4ff958ebf296b2bf3af2cc8514fbd592f287d0"
    sha256 cellar: :any,                 x86_64_linux:  "545bf943d122962ac3205752407aed236f45218bb5eb187bbf69f98904a8e205"
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