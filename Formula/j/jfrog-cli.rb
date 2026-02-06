class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.91.0.tar.gz"
  sha256 "96ebb2f143bda32edc87c0a5c113e634c3f72a94b93d36e83cc443d3bff1fd6c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "146e4bc60523c51c385d452fd7b67fbfc700ca515383d90ae5c4a2195ef9d7c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "146e4bc60523c51c385d452fd7b67fbfc700ca515383d90ae5c4a2195ef9d7c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "146e4bc60523c51c385d452fd7b67fbfc700ca515383d90ae5c4a2195ef9d7c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6beb7e98bbab271a0d35a933603d5a009bcacd954759c5526ac93e2a25d0b757"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a01706e7a7c1d1d278d2be833054b53ce1df6219314cea0f9acc9fd0ac034c92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3988cca7c2d7f74161bc86f3861b0b58dfe50748e452e0b586909ffc27696fcc"
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