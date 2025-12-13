class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.87.0.tar.gz"
  sha256 "56c7a2b12d4f4f506962c10ba5f0e437875d2fb7f873d0a41272d7d7a5180827"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "929f36836d1631a04bce7422e5d69ba65e29de8b40b6d567ffdc013f2fb1faab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "929f36836d1631a04bce7422e5d69ba65e29de8b40b6d567ffdc013f2fb1faab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "929f36836d1631a04bce7422e5d69ba65e29de8b40b6d567ffdc013f2fb1faab"
    sha256 cellar: :any_skip_relocation, sonoma:        "86012f51fdb16964a6b3d6560c1e312148f541f3b2c03c62ba3b2fa17fab9517"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c40924f296ea741040facd14eabfb20b12babb79b98f53f4638e820d4c9c05d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36575d8680000b3055bd1a77371c9dd96567c44181b2107d567c656be17e2bb0"
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