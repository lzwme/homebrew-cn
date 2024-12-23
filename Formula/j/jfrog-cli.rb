class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.72.3.tar.gz"
  sha256 "43ceced6f8baab67dcf5e53e31c7dbfb8c4e233d750e95dc5270de279a16c986"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3fd810810c9916662b8a8362e9b1d57c9df2817f22260e0000f30d877f9abce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3fd810810c9916662b8a8362e9b1d57c9df2817f22260e0000f30d877f9abce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3fd810810c9916662b8a8362e9b1d57c9df2817f22260e0000f30d877f9abce"
    sha256 cellar: :any_skip_relocation, sonoma:        "df9fd8c552042a1d4b70d1134d941dc26b8cf81b66df0fd69bf9508c55ec5cff"
    sha256 cellar: :any_skip_relocation, ventura:       "df9fd8c552042a1d4b70d1134d941dc26b8cf81b66df0fd69bf9508c55ec5cff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa208f291abf5e83cc7429190e83fdd865a80944a5e244cc194a2b0115656710"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin"jf", "completion", base_name: "jf")
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