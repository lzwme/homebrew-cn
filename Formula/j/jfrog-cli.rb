class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.79.1.tar.gz"
  sha256 "2994726e7c0b335dff5b57aa3a62c8cfc884aaf0bdf01bc2b7db17a6228edba8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bbc5c1a1e4ddc35a6cc8f835da25fd5f1202d12b0c9db2077f108e1c9af7654"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bbc5c1a1e4ddc35a6cc8f835da25fd5f1202d12b0c9db2077f108e1c9af7654"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bbc5c1a1e4ddc35a6cc8f835da25fd5f1202d12b0c9db2077f108e1c9af7654"
    sha256 cellar: :any_skip_relocation, sonoma:        "f48dc953f6bda9b56a4e3ed012a0457a40b7578ec959c34a54d6a0754eedccc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "035defff2bf0b2f69fd414ce9af889ec337eb670b1610514d19abfea85155462"
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