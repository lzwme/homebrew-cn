class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.82.0.tar.gz"
  sha256 "e0e260e6df1de0ecd409575f124259fb4a4886d09ca616c300dbcf90121fee2e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "490f77e2b6e54c5cf74e922b222dfe8d16c7e01ea0de2d9bf53dc154fe1a5b13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "490f77e2b6e54c5cf74e922b222dfe8d16c7e01ea0de2d9bf53dc154fe1a5b13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "490f77e2b6e54c5cf74e922b222dfe8d16c7e01ea0de2d9bf53dc154fe1a5b13"
    sha256 cellar: :any_skip_relocation, sonoma:        "425bd560fed3bd507afeca1de56e88018ddeff60310630f2de5f8da3ad36e3fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34a66e6f8802ec4cfc563471e9a0dd993fba41da96885d3630c4be3103f23057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b156e17bf9cfb4e66682c6126d1f09bf59bde1ee3a62a2d1dc2d9618ceea6e06"
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