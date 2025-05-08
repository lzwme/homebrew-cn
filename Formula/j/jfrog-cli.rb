class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.75.1.tar.gz"
  sha256 "ec3e9e87d89163afbeaaf4019510c24db3b9614599e4ff45a7af1d60cb015a48"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bd715f6e84a63cb4fb1c8709f9d37d6aa2b4c17c92c5ca2c72df5af75924fd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bd715f6e84a63cb4fb1c8709f9d37d6aa2b4c17c92c5ca2c72df5af75924fd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bd715f6e84a63cb4fb1c8709f9d37d6aa2b4c17c92c5ca2c72df5af75924fd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "409623dbbae34169b7e14c8ea2d3c146227f73c7df2cc85f2dc4c422e442e02c"
    sha256 cellar: :any_skip_relocation, ventura:       "409623dbbae34169b7e14c8ea2d3c146227f73c7df2cc85f2dc4c422e442e02c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5299524cc36404cf42b169e1b8bb8d335d3843d70c2d7cdcd18083cf9e3a6f3"
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