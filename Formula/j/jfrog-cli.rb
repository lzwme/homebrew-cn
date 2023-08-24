class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.46.0.tar.gz"
  sha256 "882204e68dd9740293a04b8841646cd8c28d56541d3b6d71558d1f08dfc7228a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76bc2d71de4693bd0f5aca92b78da006541e144ed091c0b7a69c339ff38244cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b4d6fa98a710c4d8e1cde3c38707c3b152e2ffbc471c5f4a74335a2ba52c8da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c97a231a75afe66a7f5fcf9acabd95faadbe0ea3476df3be41de04c7d7413272"
    sha256 cellar: :any_skip_relocation, ventura:        "4888fbc005e8cadb8ef796726779afe8c68df60665da9ddcf300c54223ab8953"
    sha256 cellar: :any_skip_relocation, monterey:       "609276f5ec84ee980a0b28b773f69a9096f54d6f92c0a0a74656115703bcbfaf"
    sha256 cellar: :any_skip_relocation, big_sur:        "82fd47549240bcf051e8ed8f4e8a6eec6b3a5417ccdf5d71ec5520a3a8a51ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5c12247a9335d5d784d0832ea5b6ac2734309d07272bdc8633d96759e0e9740"
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