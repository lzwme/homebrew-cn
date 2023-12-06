class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.52.1.tar.gz"
  sha256 "26a7cc3bf41ac80c1a8626375ef3bf580072ffec2543e25b2eca313cea96a1b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee7006a1843efe64d2645cc30719325a566133acf81522148ac04b9d4f1a6614"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "890197905dc9a95f57d4c5267337743ae93a5aef1eeac2971b8eaa02388f9ef9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db6532f3c777a44600811f7f0ce7ac158fa22315b0ba88d9814b76f041784422"
    sha256 cellar: :any_skip_relocation, sonoma:         "b809cd0e8b4cf49a1ceb52ce3db12ae9fe7842eb701b8bc3c1942c07b2978cc3"
    sha256 cellar: :any_skip_relocation, ventura:        "3419563dab0adc4314da5aa819c8a53a261f44e8506f036cfa736ed6c53e95ed"
    sha256 cellar: :any_skip_relocation, monterey:       "4aef23216a7318e892f6a330de1bc0ae0c94f102fb0cf6c581c735b52dfeb8ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f705c0c218171a02f0d6cc87328862eab0f3f0545d220d3cd498a2e47484af09"
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