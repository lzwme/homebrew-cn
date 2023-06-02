class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.39.0.tar.gz"
  sha256 "c79dac55d5b02583f747ba3d25c74db8bef0e8e1ae7a0141007574558db66de0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42c3d7e6463a054c26e90c87668393cb2b6849c22ec6e9860f29db99820efc6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42c3d7e6463a054c26e90c87668393cb2b6849c22ec6e9860f29db99820efc6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42c3d7e6463a054c26e90c87668393cb2b6849c22ec6e9860f29db99820efc6e"
    sha256 cellar: :any_skip_relocation, ventura:        "32d4bd2307735a92e8a9b6c3c4a1b59677b71ebd341f463ee3a5686a2be05ad7"
    sha256 cellar: :any_skip_relocation, monterey:       "32d4bd2307735a92e8a9b6c3c4a1b59677b71ebd341f463ee3a5686a2be05ad7"
    sha256 cellar: :any_skip_relocation, big_sur:        "32d4bd2307735a92e8a9b6c3c4a1b59677b71ebd341f463ee3a5686a2be05ad7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d47f6e4ffdb1a3ec2e02194c701d595ba37fa8f038a1a2d38f1e4be3e479728b"
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