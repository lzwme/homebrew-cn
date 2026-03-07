class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.95.0.tar.gz"
  sha256 "83e78e42f3b3603d29c15442dec380073d56c786929c4511f140e721bcf99576"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9a518bb47f0b331ec19fab4f2ec63d9a6481c11ff9a1f712ef5c82c64456050"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9a518bb47f0b331ec19fab4f2ec63d9a6481c11ff9a1f712ef5c82c64456050"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9a518bb47f0b331ec19fab4f2ec63d9a6481c11ff9a1f712ef5c82c64456050"
    sha256 cellar: :any_skip_relocation, sonoma:        "da39013829e40e0889e90e6268a300886299a4d7f93c0d5cb509c0db41fd8b3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dd28ab5843b8cd15597f59df1b9be2bed9927263e35234f0cd48771a23b5479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad2ee8b8f64e4f935d9d87227d14aea79d6607a5ae771231a4ed22f330240743"
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