class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.34.5.tar.gz"
  sha256 "78b30429b1bef7e8d0836921c70bab53bc2dc4de3123a361d2f6ae1041f15ab6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a93402b7b47e214c2a923c9949e5658e54bea02c9fbe710e15a522b840488bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "123db7c7780185a7e757f78b93ed5c54904b4328cc8223d9425f9a007fd6841a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1350952e04b9e87290209cbad6820daae0766993215dadf13626480a43ac4a45"
    sha256 cellar: :any_skip_relocation, ventura:        "dec125392b4194a0b5c6faad6f9c760610dba31698ac59d1dcfc019b57fe6fb3"
    sha256 cellar: :any_skip_relocation, monterey:       "631a374c74e27ed440a000b915ed6aa8b8c2f02fbb3cc5eb5c43993733a485c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1224af2c8b3233af97af9a255126816ad5edec204516d1b070f8a1039225f0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d62a3d8cae8f72fda53bc8e485cc537b9ad79fcab5c126094e3ca0b35db5c8c"
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