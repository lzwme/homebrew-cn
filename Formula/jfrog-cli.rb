class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.42.1.tar.gz"
  sha256 "9a13699beabae75859910b4246f6eac688e4506badbbd0fcbd511675a3ae1620"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a166c6974e0eb1f2fb23696a6176a7ea17ad05f71264ddb45b5a5fcced28ce8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a166c6974e0eb1f2fb23696a6176a7ea17ad05f71264ddb45b5a5fcced28ce8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a166c6974e0eb1f2fb23696a6176a7ea17ad05f71264ddb45b5a5fcced28ce8"
    sha256 cellar: :any_skip_relocation, ventura:        "3f0083c57eda7b7a3b441ea0f018874bc098b066a22d40b2d2f2c7771e7aec7d"
    sha256 cellar: :any_skip_relocation, monterey:       "3f0083c57eda7b7a3b441ea0f018874bc098b066a22d40b2d2f2c7771e7aec7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f0083c57eda7b7a3b441ea0f018874bc098b066a22d40b2d2f2c7771e7aec7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eff531cfb6eda7a373e7ccff44b121494fe030d94b7041d4e4eb93f63e054240"
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