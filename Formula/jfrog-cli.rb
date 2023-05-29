class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.38.3.tar.gz"
  sha256 "81eb7d8249611d7bc1f4ec5a816197ae7b90463f25121575848d40df34131551"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45c963ea6a74e7232986d7d6c4061932e5099b287680c63c696ad31e8679294b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45c963ea6a74e7232986d7d6c4061932e5099b287680c63c696ad31e8679294b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45c963ea6a74e7232986d7d6c4061932e5099b287680c63c696ad31e8679294b"
    sha256 cellar: :any_skip_relocation, ventura:        "e64d298536a9d1df60d280f85b5e946eee45fb152f5f19af651afc34bdc537e4"
    sha256 cellar: :any_skip_relocation, monterey:       "e64d298536a9d1df60d280f85b5e946eee45fb152f5f19af651afc34bdc537e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e64d298536a9d1df60d280f85b5e946eee45fb152f5f19af651afc34bdc537e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "667e08d128caad0e510336c2e69c6f3c4c14b2fd31c25005778f78a8ef7047d9"
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