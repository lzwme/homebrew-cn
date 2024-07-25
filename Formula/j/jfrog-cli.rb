class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.61.0.tar.gz"
  sha256 "e4dabf03d4289f50cf2dd646ae23c8c64b32113ba1aebcd2fb11ae8d26c18e21"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f86aa76975e33083263dcb24d8d5be70a1e2e90cdaba32016d1e0d09a1f00fdf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95780af00e00d6a2c5f80b26a6ab7f6415842d04876b85290b425d29abad8800"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b9f496c93d9c8d732ba6aa5c3ba0bf4d0bbd58fa38cda807a0ecdd4d6230016"
    sha256 cellar: :any_skip_relocation, sonoma:         "a33af81657e22492f55b405b18fefd6196bfa4b6391f19ae60b77cce088a8632"
    sha256 cellar: :any_skip_relocation, ventura:        "99f354492268cffc2f88567f4f19527151a19cf63d28a6a05b2e1d9617db027c"
    sha256 cellar: :any_skip_relocation, monterey:       "820e7e2d23ee7b94fd68c7bcd154b7d0b646a013bba9f9581788288d33d21cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c23c9bc694ff509bd0c67ab1a5a30a34b7576992a0fb114906fd29d37f45266"
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