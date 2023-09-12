class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.46.3.tar.gz"
  sha256 "d2348a2c057f1ed0770987725d00a1007c5865cfa7e78912b0fd1a6296c064e3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa4421d50f0fa113a1484c40528f7b62710d4592514478ae44efcac5db8a4316"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9c29b4b30ac8b0a9a01a5d86f3e99600b50e16da226724997f5cf53d08eccdd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b447e257f6aafc0ebce4ec38faf0224d75e8ccdb3ea1583e39084ea46826b38"
    sha256 cellar: :any_skip_relocation, ventura:        "1cfac93be42da8e5df0bb427aa10c5c33521f6dfacd7637cc79a7701c4a737a1"
    sha256 cellar: :any_skip_relocation, monterey:       "f67846e38c4f357acebd0c14828d54a53555981328b815a17f95713d001b497c"
    sha256 cellar: :any_skip_relocation, big_sur:        "90f8003e879f1106560e67bcac417922662c90c3315f1fa6c2e70f8bd11cf1b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56dc23abaaefd2c2175c500c32247ee04a6a60ccd0c373c66b1f88d2f066864a"
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