class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.68.0.tar.gz"
  sha256 "da85ac4deee00ecd8ce73c56a56196ec94f4d01ca21ab52517111abb275a4e3a"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c9d34620fe9d2c9affa2460917bd558907f9d8e9e3e98563451f5769e4b4821"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c9d34620fe9d2c9affa2460917bd558907f9d8e9e3e98563451f5769e4b4821"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c9d34620fe9d2c9affa2460917bd558907f9d8e9e3e98563451f5769e4b4821"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3c05bb55c7bde882de64d6b33750ceba9b4388392cd4ceaf5a6f34397535021"
    sha256 cellar: :any_skip_relocation, ventura:       "a3c05bb55c7bde882de64d6b33750ceba9b4388392cd4ceaf5a6f34397535021"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31ded2ec48ddef2f2d06fe57ad3ca2975ec11e799dc339a0f8a038be561f93ec"
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