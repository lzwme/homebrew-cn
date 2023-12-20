class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.52.5.tar.gz"
  sha256 "b437cf855a3b5c66cb180b36965881a0b4bca3b853a47d9366c8e65460366b71"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20d2b45462cd004972541bd01367e5e12ced167ccbebae13c2368450ab60cf83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee1dad350c715b89eb8e80dca1b7adf2520d093f298006af3611658ead7d712a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed0bc12f220731efd2df06531f01d2d4f20d9fcd3511685e1fdda8fdcc581a11"
    sha256 cellar: :any_skip_relocation, sonoma:         "d0ab54bfa1a9b87bd946fc226279ad6e40a938747dbb12731c59fa1e1b0adc18"
    sha256 cellar: :any_skip_relocation, ventura:        "2009ab86ee64b956fb7aa713dacc465c8e4fbaeb251a4f8e262995703cf862a1"
    sha256 cellar: :any_skip_relocation, monterey:       "f08b2c9a1659dc8c9431976e4969b187e0f1b26952bdfcbce8e474fc6be2d1cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "975e37c585da918306420d87cf4f00dbc406da88d98542f89b0bddb1415ec7ac"
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