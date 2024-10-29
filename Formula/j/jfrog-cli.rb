class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.71.2.tar.gz"
  sha256 "ccaaae4ef2f161973ee3e5631c05946a426d2d5adf2e34e83f15e13ff60cb3ad"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c3d6124f74d2555b6efe6a86245766cae1ae06ff851d0a0a01a9125652dc86e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c3d6124f74d2555b6efe6a86245766cae1ae06ff851d0a0a01a9125652dc86e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c3d6124f74d2555b6efe6a86245766cae1ae06ff851d0a0a01a9125652dc86e"
    sha256 cellar: :any_skip_relocation, sonoma:        "833bf48a942210e702f1368334ef5a2349d9fd0a5547b1a0073cf7904d02aa26"
    sha256 cellar: :any_skip_relocation, ventura:       "833bf48a942210e702f1368334ef5a2349d9fd0a5547b1a0073cf7904d02aa26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfffa81522b26cb1a09bce26e11c617d86f96d13d2f1d8ff3e84ff37512294a9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin"jf", "completion", base_name: "jf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}jf -v")
    assert_match version.to_s, shell_output("#{bin}jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}jf rt bp --dry-run --url=http:127.0.0.1 2>&1", 1)
    end
  end
end