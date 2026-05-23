class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.104.1.tar.gz"
  sha256 "8bdf54c6eadaea39a29da69d68bf548c5a718c7a241e0d77fa90b46c51c21699"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "651922a1f34ce88562defff515fca60264bfbecfc3df5a160da05c241b2cf322"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "651922a1f34ce88562defff515fca60264bfbecfc3df5a160da05c241b2cf322"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "651922a1f34ce88562defff515fca60264bfbecfc3df5a160da05c241b2cf322"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ae57f2453c54cad7d5a73f0d6ead25c6b79bcdb80d4b243383065162f10fdf2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8818d13e044f92e4e8d18d966f954f5e522de64f03d5407ff2b0366c9334476b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2913c6ef4393f95f774c9c0dcc2ad9b9a34e31d641b1279a40053effdccdf7ec"
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