class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.59.1.tar.gz"
  sha256 "4047f7578bb7b58019a035902e6dd11f6f34e2c36bea8df4cd1911df4f4fc789"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "123231b9903d2c4f3e47e59726a4c8970ef5d07da2ceabbb02e166d0077dac79"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a0ebcf82dfed90da8b565d4ac9e9bb5aacc5853c63cd700d6112522b46dd181"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9c88f3b9b28d98fe818d0aac7029e7621a02ef48a0fe8886552aa8151443853"
    sha256 cellar: :any_skip_relocation, sonoma:         "e31bad6740884b9ad7d2ebdf6be907280af0d7cb37d1b2fb7c37ec1abc1deb83"
    sha256 cellar: :any_skip_relocation, ventura:        "dceec97941b694a4c9bba933a378fcd4d2e07540c4bffc0b4b73f09e357a2412"
    sha256 cellar: :any_skip_relocation, monterey:       "2d4b7ed7be443e7630386254f764d94616694a7297655e8e1200b2f722bd5579"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33f86c249eee8f85b5089b3dd0ea2d3f154d22d316ad93acc4f70af141f5486f"
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