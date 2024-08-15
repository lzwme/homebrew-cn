class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.63.1.tar.gz"
  sha256 "5b261914471b786c0e73546cf834f40d42c299516c75d06433420640e4292353"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d46671c4570c8e723b46f5b818b648192fdddf891b8366788f3d0e1a791731ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6868f6154fb1189b4dcb53684dfe359a081bd3fbd73721244bfc2d75274426a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ee2588a7592bf0121161c6721697b96861d923e8626c84f4990130f58b4cae1"
    sha256 cellar: :any_skip_relocation, sonoma:         "00f68264a58c19b65ea35ce3d66c08d722af6964f9f45d30a897344906e78093"
    sha256 cellar: :any_skip_relocation, ventura:        "3b9e2cebaab04a513ebcfaf22c1c3b31980297d73ebebcd374c825f68c88b99e"
    sha256 cellar: :any_skip_relocation, monterey:       "72a366538fac444b3b8a052e3289bd47935e370c3d95b3a8832bfbd34512958c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1874088e399d4087bcaa96561517ee5efbad240dcd61f9a93bee0221995a2510"
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