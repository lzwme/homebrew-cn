class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.71.5.tar.gz"
  sha256 "2ed60d31ce955c1b6d9385b38d230fe7c70d7cc225345b85e7a3daa7402d6db5"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fdc9ef160dc6e3793cb886b5c26630b216ef381a2d24ce56c4860affda6d265"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fdc9ef160dc6e3793cb886b5c26630b216ef381a2d24ce56c4860affda6d265"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3fdc9ef160dc6e3793cb886b5c26630b216ef381a2d24ce56c4860affda6d265"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad78fcbe91a57c9a0865885dac4aefca12be8bab31eae66933285af90a49f00a"
    sha256 cellar: :any_skip_relocation, ventura:       "ad78fcbe91a57c9a0865885dac4aefca12be8bab31eae66933285af90a49f00a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f61df32c04755964beac5ad650fe4a72ceaae77be8dc099490080d162e7d813"
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