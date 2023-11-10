class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.51.1.tar.gz"
  sha256 "1e128b74738f8fbe246ba30f785ad004b9a0c5df0a728a363dac342f660b5cac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "005738d298926597b6fd5e7c1fa10d29825afe9008e9545e5a0a723aeab705a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d5269788c81146e3e50d391803d21ece464564e8c4c25e326a07d9da3c6be9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1dde8fa61793a0b41ea90e05247ad66c2a8baed8cd76148622749a4ede84862"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee4ce75619c2196b33727a2ad481ddd8d531f63ef0b1f5cd168597253758c68e"
    sha256 cellar: :any_skip_relocation, ventura:        "c7520d4dcc6d8dcbf695ec1ac7f1edd3affacf0d8ba0e9ddcee19ac2261ba1cf"
    sha256 cellar: :any_skip_relocation, monterey:       "ab9995a74755807c0e019823aeda72bb74097b6c0eeb40dfdd119b2fbeb8fdb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "506a042e63e1a5873b2b2bb14a63b3b65d8b95bcde0dafc7dbd6174f8c02f43a"
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