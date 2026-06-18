class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.109.0.tar.gz"
  sha256 "0d246b65bffab877e0e01c1ac9ddefaa5151e278a0c196406b5843551d2e49d0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5230e4c234d168b0397ac3382fdc3755e6a87af1b9d46433547d2229f7559ff7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5230e4c234d168b0397ac3382fdc3755e6a87af1b9d46433547d2229f7559ff7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5230e4c234d168b0397ac3382fdc3755e6a87af1b9d46433547d2229f7559ff7"
    sha256 cellar: :any_skip_relocation, sonoma:        "29b98c602d3fc91364719900bc376c363d316004e27092d91b584f33bb43ede5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7713c941b6f2bf90ad1019c64f186132e963d8f17bc0bd15c041a3ef76ec6e85"
    sha256 cellar: :any,                 x86_64_linux:  "aa0a1fb1be6997967fdb680c22c2d51fc3b0365a9d410e312514386618bfdf31"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
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