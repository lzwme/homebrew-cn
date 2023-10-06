class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.49.2.tar.gz"
  sha256 "56c51f26a78db1853ebfa5b06f3f1d4924f8067370af7a32bce93edac0a2b558"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20d42062f3094db00443707e92c82da80c3c5ba421a32bb09a25a68380991127"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ddb56eb1860f0950b5ba857d6e29dddb30c0352eff479e882c35aa6d666baec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5c04f6dca619935f73550319a860ce718df43ae4fa0f7ed8da801eeaf1f89eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "e24a78e64cbe211d5e37c32fba6662339901d97d18cc2bd20cd23bc4180e4037"
    sha256 cellar: :any_skip_relocation, ventura:        "ffbe5993204ea595d29aaea0acfdcd410f24bb3941dec8850759ff2a552f7086"
    sha256 cellar: :any_skip_relocation, monterey:       "a175236c602a5968c82b8e62e2e0e304adc3a71a13fa2e7c9413bbb5a9a1a68b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad4da2b510683d1a132133099932d4f53b917ac2788baab8d2447e4a1ee5d779"
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