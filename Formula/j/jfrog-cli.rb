class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.74.0.tar.gz"
  sha256 "f0e6d568c0b053c45cd0165bfc03ae6c806cdb602418ffa05b0e30dd4ad8c684"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6f9648720a2d3c308c17c49f884aed8abd052589223d25a7e668bd564ae97bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6f9648720a2d3c308c17c49f884aed8abd052589223d25a7e668bd564ae97bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6f9648720a2d3c308c17c49f884aed8abd052589223d25a7e668bd564ae97bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "87eccac3fae5d121681cefe5a2e873d4ea7ab450d68040cc610d8b3807117a74"
    sha256 cellar: :any_skip_relocation, ventura:       "87eccac3fae5d121681cefe5a2e873d4ea7ab450d68040cc610d8b3807117a74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f32a0834397686de0fb5cf3599cba183dbe67b28c643d6e81c89275bbff18f4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin"jf", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}jf -v")
    assert_match version.to_s, shell_output("#{bin}jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}jf rt bp --dry-run --url=http:127.0.0.1 2>&1", 1)
    end
  end
end