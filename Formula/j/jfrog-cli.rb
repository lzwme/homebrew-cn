class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.52.0.tar.gz"
  sha256 "5553587bad739e567b66b25d0f7c5587ce899233fefe642ddf8feca5e6134832"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5952f88624e0e819be5e3bf0df66915d1648f3d94021e73fe7dcd0ecbb308073"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a407ebe716ed6a4f2f10c8e7832d4cae804c80c26049533f23e18ae073c03fd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb6fb0065ac92fe2f95563b2a1afdb0bf1461f09b71904f43963ac963192eaa5"
    sha256 cellar: :any_skip_relocation, sonoma:         "621ec1fcad3fe0b493c82eeb0097177f85f1c2dcbc43bc1dcd35c7caec7d7fa5"
    sha256 cellar: :any_skip_relocation, ventura:        "174a6fef3b4d04d184bb0a722a017e5cec1b7b06f28b3cea35e6122862cdbd48"
    sha256 cellar: :any_skip_relocation, monterey:       "f116e95b3244513e1cbd279c11da98a44b7c3e79a25d1c61f595c3aa03bdc58f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "890a2b54f09d0f2fe68e32422ff4d3c713b456910fbe3039da4d1a530e8f343d"
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