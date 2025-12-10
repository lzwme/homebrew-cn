class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.86.0.tar.gz"
  sha256 "ec7d5f8ba4ce0049c3d1d7a400688c1a176d7f0cd32e828e548cb2fc1ff8e8f6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9162860a18b0fa912dc8aa41c1f05fc34b52a848436b605bdfa9ff8ff3e3549"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9162860a18b0fa912dc8aa41c1f05fc34b52a848436b605bdfa9ff8ff3e3549"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9162860a18b0fa912dc8aa41c1f05fc34b52a848436b605bdfa9ff8ff3e3549"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a7d703769109e8474125f06d1034c340a8676d850624816a362339cfa06d64e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c0ee3370514e0e6d86b55ea20aa76f986f249c28fbd625c510b9a740626b6c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cff9f5954a6039f52d0a6d3905234642e3228ca2f56072bd54ce66e940b3a02d"
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