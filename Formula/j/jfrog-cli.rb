class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.57.0.tar.gz"
  sha256 "3ec3ffd3596a2447df3a89d67f9803996c4404884560cfc8b74ec013b5ac25d7"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a97c947efce1bde9f944fa2351d722b7bc1c9698605b42ff6be9b66fef53f7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09ca1fc23a07870118a0501c103a9aa459197a611ed39b5eb8a1187fdc7088ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "551dda5d56525712cddf28338c4cbca792ffa22eefaaecfc23a42369ae72cac2"
    sha256 cellar: :any_skip_relocation, sonoma:         "754985c151566c5a5f854ccf224efea4fa5b0245ba27963954b1bc0fc3fe86a0"
    sha256 cellar: :any_skip_relocation, ventura:        "cc882b36c042d8543e1694c2804f9d6a38a145868f05a2eb1e2b0c3d09e65dfa"
    sha256 cellar: :any_skip_relocation, monterey:       "d63c8c313e4ca9d46f70ffa25d7547d987d9d52f78633e895502524359313bc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8d36ae238a042afe7da48e26341930a3380d412da02fb5c39147a61a3df0bae"
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