class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.89.0.tar.gz"
  sha256 "8d34f186aca9fd3c66510192f0795868631d955ab8263454bdee5500f39d0133"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a415e1254c2e77da2dc738e57c891064b30d4e441a4cc69cac71cbe43d1acb95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a415e1254c2e77da2dc738e57c891064b30d4e441a4cc69cac71cbe43d1acb95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a415e1254c2e77da2dc738e57c891064b30d4e441a4cc69cac71cbe43d1acb95"
    sha256 cellar: :any_skip_relocation, sonoma:        "0085f9c6ce71e9289e2a67bfc7e7d5115bc60a607775b8b304df4243ed24e880"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "886bc8243d85b947fbeb3a31099424fe66f31c867ca5373c18d44e1798a761f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ec441037c584223acdc52da89d653e4d05bca1c77aaf2d3e52b411d2fc8e35b"
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