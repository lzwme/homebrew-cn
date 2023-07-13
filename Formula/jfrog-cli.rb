class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.43.1.tar.gz"
  sha256 "30fef29caf9677d1e764a2bd88e3fb2d033f0f58eb575f1d2a4b7360bf5b9c5d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba5e420ce05f267af9fb0fabd364ffedab1056586785e61f47c12ad763f6ee16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba5e420ce05f267af9fb0fabd364ffedab1056586785e61f47c12ad763f6ee16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba5e420ce05f267af9fb0fabd364ffedab1056586785e61f47c12ad763f6ee16"
    sha256 cellar: :any_skip_relocation, ventura:        "4b5f0e1ef31c1ec129b077d71eb58349094543a2c261d3ed2731ee32cbfa4e40"
    sha256 cellar: :any_skip_relocation, monterey:       "4b5f0e1ef31c1ec129b077d71eb58349094543a2c261d3ed2731ee32cbfa4e40"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b5f0e1ef31c1ec129b077d71eb58349094543a2c261d3ed2731ee32cbfa4e40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6830d4679a74daed038675656edc0a2611464fb9d1b366017a8c712dbc101ea9"
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