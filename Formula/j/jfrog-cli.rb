class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.101.0.tar.gz"
  sha256 "b39bb1a9b44ea01d56f463998193cdbe1ee5f4dd79acda6736c87e328cdb06ab"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfec9d417547c022a06a22982d2aa0e768949b032d75ce96eb128bab468359aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfec9d417547c022a06a22982d2aa0e768949b032d75ce96eb128bab468359aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfec9d417547c022a06a22982d2aa0e768949b032d75ce96eb128bab468359aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e8d064cd91a5dd57745bfed6dbf1c18f075ed77134a14d0a405b903e5bf4a75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2e1bd63aea152cfa3cbc6d59df8d0d4205a566b754e620242162e9294d1271a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee18f0f5b48070db010481b445e8e42a365b935fab38b9b57d5c8605e143f493"
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