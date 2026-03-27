class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.97.0.tar.gz"
  sha256 "73a41ebe7b068212ebe4e125b71483dcf561d273cae90768db72d160ee7dc206"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e39a46ecad6f5bec35ae1ae09bf224946649279045d1ff4058fadf8f8d095b7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e39a46ecad6f5bec35ae1ae09bf224946649279045d1ff4058fadf8f8d095b7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e39a46ecad6f5bec35ae1ae09bf224946649279045d1ff4058fadf8f8d095b7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "62e64c3ffcefdb128d9874bbc139d30b95079b264ccf4f7c4887ea4aae2857ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fce324bd94e4ca1ffd252104dd48d0c971c4a8fab6304a541a1bfe530b84768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2ab4c9f3c888d847a99e704143dedf959cc6892d99f09fd969c5d1f7dbfd927"
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