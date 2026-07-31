class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.117.0.tar.gz"
  sha256 "f90d930aed97ac6b3b2357a5984cf0deafe6980ee335ec5b2984f5b3a26c7eec"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "606b02b87440e515261e3acb2437c896e0b890c1d00f06ed49ef8a5c1f76ae32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "606b02b87440e515261e3acb2437c896e0b890c1d00f06ed49ef8a5c1f76ae32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "606b02b87440e515261e3acb2437c896e0b890c1d00f06ed49ef8a5c1f76ae32"
    sha256 cellar: :any_skip_relocation, sonoma:        "074daa8c05536b3098095f518e9c38e87c1f712f3e3f855cb7238fb7c9d1db5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69910505c834e0ec3bae9382ab041273014b9bd083171c649c1893149a85d17f"
    sha256 cellar: :any,                 x86_64_linux:  "5030a34cbde11957d0af1be5714f88d2755e00cac825702e8d4c23b35d17e5ae"
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