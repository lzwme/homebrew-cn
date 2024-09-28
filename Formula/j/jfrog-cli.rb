class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.70.0.tar.gz"
  sha256 "0bb7e009a9148026cc5e3acd93a692d72841da42fdd301e0892a9f6e1d949db9"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "145f7c81c2f912229cc7701c0c9025970bab1d28f16183c8513df31fa6fbcb23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "145f7c81c2f912229cc7701c0c9025970bab1d28f16183c8513df31fa6fbcb23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "145f7c81c2f912229cc7701c0c9025970bab1d28f16183c8513df31fa6fbcb23"
    sha256 cellar: :any_skip_relocation, sonoma:        "9826c0e4217d90a185ecf6d23764cb71e0b4b783ef378343734e58d3ea1701c6"
    sha256 cellar: :any_skip_relocation, ventura:       "9826c0e4217d90a185ecf6d23764cb71e0b4b783ef378343734e58d3ea1701c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "093dbf2f0648d9a732ed32d5d5f5de8b57b94878aac63852e42fa5385578b369"
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