class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.44.1.tar.gz"
  sha256 "8886e730efa580937dff9013a36b8f20d90f07ca488105799b0a4c1f4ee36ac5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f617e36f1ad1237e7da98892d819895d6140e806e19feb5db0f1d6c9418e3cbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f617e36f1ad1237e7da98892d819895d6140e806e19feb5db0f1d6c9418e3cbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f617e36f1ad1237e7da98892d819895d6140e806e19feb5db0f1d6c9418e3cbd"
    sha256 cellar: :any_skip_relocation, ventura:        "3ed467868a15695d0a64487c45d8650d7b81a8d54e801e45721a98ac3eadfffc"
    sha256 cellar: :any_skip_relocation, monterey:       "3ed467868a15695d0a64487c45d8650d7b81a8d54e801e45721a98ac3eadfffc"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ed467868a15695d0a64487c45d8650d7b81a8d54e801e45721a98ac3eadfffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0cee0b1761b1368561bae83a350aff3a122b50afe450254e0cbdd7a24502c02"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion", base_name: "jf")
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