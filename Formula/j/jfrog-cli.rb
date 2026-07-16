class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.115.0.tar.gz"
  sha256 "b2c9a4e4712b00dee30f35e0945c0460b0529ab0543d76a245da30da0be528c4"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5143e2ef27d60aa8c4279c928840ccf09d22695dd9481941dca81e577ea32a2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5143e2ef27d60aa8c4279c928840ccf09d22695dd9481941dca81e577ea32a2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5143e2ef27d60aa8c4279c928840ccf09d22695dd9481941dca81e577ea32a2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd191ca73f48f8065809923308fb6d15785f27a5099030381f3a8e39193f961a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ca31d213f795e291a8cb30767c95e8b05c3c5c8a95d60ecfe6cec99c30b34e5"
    sha256 cellar: :any,                 x86_64_linux:  "eeac291c15f0ac712702330593e2afcfab841c2542e26dd6f53b7309d340ffe4"
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