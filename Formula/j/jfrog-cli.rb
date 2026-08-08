class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.119.0.tar.gz"
  sha256 "1344710d74c4b699dd1336714e859e7c130574f27a7f1c483ddb7afeb46abe54"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3471077f2d265bc8c5ecacce48cc6bfcaf441badc5cf3c6ed9eb6f90dd48bc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3471077f2d265bc8c5ecacce48cc6bfcaf441badc5cf3c6ed9eb6f90dd48bc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3471077f2d265bc8c5ecacce48cc6bfcaf441badc5cf3c6ed9eb6f90dd48bc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "830381db32e820f3410d7d7504ba4878fdb18e2a0093bbfd8e506b5821d07c1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "580db952886c3ea7224972688b2bfdbf082ffd86f5dce5e67ab75a053a3fb378"
    sha256 cellar: :any,                 x86_64_linux:  "082566167718591a898d345a894e81d93ebf4f2151a37adf0e1bf9217751144c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion")
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