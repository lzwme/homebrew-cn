class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.122.0.tar.gz"
  sha256 "a44607e65f344023e18ab3197a4c116c601b5f252a0876dcba8da09b3fb93795"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf14ba68f27a255cedb32349a107c0391674f46f75d0216abe3fe38e9be5ab9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf14ba68f27a255cedb32349a107c0391674f46f75d0216abe3fe38e9be5ab9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf14ba68f27a255cedb32349a107c0391674f46f75d0216abe3fe38e9be5ab9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "816c3d3b1b0d78bfd1218cefe259a9662e3e081ca40d367024c05bd68bf6bbb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b206187fa02dec86a71e1786b9b1f8f0405570c3d9c05396e8de06bf8c3c802"
    sha256 cellar: :any,                 x86_64_linux:  "36eb9273ff95464f6b7c257f11a3a88150046096519275479a8d5cd0faa61a4f"
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