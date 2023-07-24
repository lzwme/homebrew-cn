class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.44.0.tar.gz"
  sha256 "69c1084caacd911370d81a8eee8e6fb95ed4e9959e377234c3a1ec6d0cf6e404"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8890192ef40c2ef099eaf4e2bfb8b067a99721718aae6594115c447006246479"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8890192ef40c2ef099eaf4e2bfb8b067a99721718aae6594115c447006246479"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8890192ef40c2ef099eaf4e2bfb8b067a99721718aae6594115c447006246479"
    sha256 cellar: :any_skip_relocation, ventura:        "ca10b946f45057690e471a9a50a7d1ae8f9a25544525a1d185ab955fd12ab3ef"
    sha256 cellar: :any_skip_relocation, monterey:       "ca10b946f45057690e471a9a50a7d1ae8f9a25544525a1d185ab955fd12ab3ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca10b946f45057690e471a9a50a7d1ae8f9a25544525a1d185ab955fd12ab3ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51f763b2fe4fbddbc7ed3ad27f6673159fdc73ea887932a4db560d3fa2fe9f18"
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