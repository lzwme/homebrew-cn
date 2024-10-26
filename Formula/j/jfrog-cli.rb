class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.71.1.tar.gz"
  sha256 "ef4af045ccdeb5305c60d8ac1e1faebd6e4501486737d8198034d4606edbbeb6"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afa94ad09ac1d3b6d21da2d997b270a4355c2487bbf4b3b1ce522726eca5fc96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afa94ad09ac1d3b6d21da2d997b270a4355c2487bbf4b3b1ce522726eca5fc96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "afa94ad09ac1d3b6d21da2d997b270a4355c2487bbf4b3b1ce522726eca5fc96"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e83935c29f007b8a10b9d554eae9d4842e005f5072d03f5f144774d4fa2e024"
    sha256 cellar: :any_skip_relocation, ventura:       "0e83935c29f007b8a10b9d554eae9d4842e005f5072d03f5f144774d4fa2e024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d1dfc41d30cefbddaced71d7561547ecdab9e9cd41393e4196336362e3c4e59"
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