class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.61.2.tar.gz"
  sha256 "6397464e2acbbe765c34989dbb6528bc83041f9478f7547857562410d345469b"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93574576cd121de79608fb5a2fc6f4724c5ed6b2a0d38f660bd7fdecd0ebcc4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41940dd9b1e98e5e8e0f5c6b0eeee0bf637004b9b9ccb6247677fb233d93bd83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b76eac60b545a8570fac408410854e8ae761016494f134a889abbbc5f6cc0837"
    sha256 cellar: :any_skip_relocation, sonoma:         "12b94b2cf42d189281aec1c0ed664d387196cc50eeb03673630a4685010047f9"
    sha256 cellar: :any_skip_relocation, ventura:        "8b3e0d4c22a26b92135b2d69859b76ba0c86a5cf5105752af0fd74ab2a502ead"
    sha256 cellar: :any_skip_relocation, monterey:       "2dda33039613d48ad7ab3f1e998f965b6e9460a6cf00d25b66547e0a5b65b4ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f277855338c141baf4e7fff1a2b02d3a463f7218e100ac0d3cb5c66a421cc6bf"
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