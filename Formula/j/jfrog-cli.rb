class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.94.0.tar.gz"
  sha256 "b48544b9975254e2318faa3d8889f8becb014524dc51a8874e6a4b9ed06959e3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a8ee77b0c5452c145bf58db127501df465589a1ec488d267611ca6ce394e810"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a8ee77b0c5452c145bf58db127501df465589a1ec488d267611ca6ce394e810"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a8ee77b0c5452c145bf58db127501df465589a1ec488d267611ca6ce394e810"
    sha256 cellar: :any_skip_relocation, sonoma:        "011db4daee289686248962a11714480b92b3adc9624a3edc824cbcc300ee54ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed2703db339a155311c5073a9316701453f3ece99d891b3e3e11dee42fc7093c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9130991115959915f2fa776da69b7ea0d01abae82e775c97b985732ecedef7a2"
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