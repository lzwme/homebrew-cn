class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.47.0.tar.gz"
  sha256 "058a5330aafbc8ec8c3fa19e7d75bd0de23a195c2d3e58a00f8f1ae2c97236fe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f22dac16b738d7fe6facedc8869e0ef4b02b81e6791254b683ee44451babf2e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86f0643f9fed383eab46b4c4442517b70139e6f2f896a129c66aaf3850c4f0ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e00a457a68f5ff13fb32a010daf7072a414f61f5e4b9085056780728828cfa4a"
    sha256 cellar: :any_skip_relocation, ventura:        "2b59a222a716a854a20b8990dec1853393bcea7871abb1771e9c2e5c9368635e"
    sha256 cellar: :any_skip_relocation, monterey:       "efbf6bfc01134328d62103750a798e96e33b41368553b325f7e2899982d63ed7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d3268e924af0d990a8cdd33cb5d37595071fa173a344a18ae3fbecf743dca69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "326995924b383aa1cce900915b5979614cefb13b1f1c5e2064aeb7c89c082eb5"
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