class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.118.0.tar.gz"
  sha256 "c29dd05a4714c10a36e9e6ea394235ebcad774c2eab4bb39565ff10716ecd0e9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18bbf02c949a0fccef1f83216dc68c6818c5808340ec5846a3c421f98d012296"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18bbf02c949a0fccef1f83216dc68c6818c5808340ec5846a3c421f98d012296"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18bbf02c949a0fccef1f83216dc68c6818c5808340ec5846a3c421f98d012296"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7ff2033f2e45ba697e33ac42e96fc66c278e119c004ce6cda9def5d61d896af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "189a825c18d0662280c552d9b5387265c9891277c03dd18705069cb6b15d1665"
    sha256 cellar: :any,                 x86_64_linux:  "d0b3cebc650e87373900d71be975b1bbee07264d352ebd3a702d755bd4898918"
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