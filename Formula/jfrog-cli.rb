class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.38.5.tar.gz"
  sha256 "b8a2c72a9b632a358fa4fcaf48ed1d6ab0117a22293459069625498d1e680fc1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5655a9ee698d4523a21a1e65d0394e57986b39caa82585ff9bde74a9e250fb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5655a9ee698d4523a21a1e65d0394e57986b39caa82585ff9bde74a9e250fb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5655a9ee698d4523a21a1e65d0394e57986b39caa82585ff9bde74a9e250fb5"
    sha256 cellar: :any_skip_relocation, ventura:        "55281a9d80a7bc3722b2965d5bbf78cd7be271b86929f5d19217588eebf6685b"
    sha256 cellar: :any_skip_relocation, monterey:       "55281a9d80a7bc3722b2965d5bbf78cd7be271b86929f5d19217588eebf6685b"
    sha256 cellar: :any_skip_relocation, big_sur:        "55281a9d80a7bc3722b2965d5bbf78cd7be271b86929f5d19217588eebf6685b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "289c793651186e5ecdf9342b2c6099d32a31b455cd0f3dbfeb6a023970bbf4d5"
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