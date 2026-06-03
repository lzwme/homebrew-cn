class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.106.0.tar.gz"
  sha256 "fa43e21a1ae2c3792fe6351a35d07359ff72bad10bda1e925b73f61b81f0f180"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a72010d60515758e01aba8f05c2af996740c2b480ed566c9b1328d39587d9d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a72010d60515758e01aba8f05c2af996740c2b480ed566c9b1328d39587d9d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a72010d60515758e01aba8f05c2af996740c2b480ed566c9b1328d39587d9d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "40bc8c43a6b1c1413a083846b30b4e59cb682de3eb29e1fa7e65f4e4b6d0a7b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37b6171003341e6661ae133971606b4d9451f4679ab9fc83f79dc18f8bf09225"
    sha256 cellar: :any,                 x86_64_linux:  "e5b3a9bc4a2acc1db467c16a8b225af5186da638d97df7f7c287a6dd403015b7"
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