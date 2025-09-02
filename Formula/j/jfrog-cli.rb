class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.78.8.tar.gz"
  sha256 "ce121daa69a813410049d9bf00bda81e8a8881ef87ac15210831977475a637cd"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "v2"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ec2c3b79fbf3c38178fd0c75fc45d089fa718c2058c2ce3d933fab2b1b3e63a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ec2c3b79fbf3c38178fd0c75fc45d089fa718c2058c2ce3d933fab2b1b3e63a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ec2c3b79fbf3c38178fd0c75fc45d089fa718c2058c2ce3d933fab2b1b3e63a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b480e5bc2d0d4e3f4cc0db03c94bbc5b9dd84a7ad6131868645dde6f8f16e65"
    sha256 cellar: :any_skip_relocation, ventura:       "c0c4f84656f178237e4ef66e26c61fa820f40bac5b06b470ea7477164097f2e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d5c65ca3f936c05752ebb3da2001c1b7113f1fe5d770b6a1c97a014cff9fa4e"
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