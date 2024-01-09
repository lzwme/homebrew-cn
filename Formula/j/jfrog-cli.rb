class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.52.9.tar.gz"
  sha256 "6bf863e2cbc1ad06d3c8507b08c7f7a99e36eae8b7cafb6d9d5f4105a7a3c767"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae0ba11ad554069127fd051fb194dd736ade30a9cb43c65625c174cd379f841c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "660bed55d38f9e12fcfe998017763fe34dba804e0e09367edc35a480866f9279"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f93e63be20966bf02e670b17ff7acbbe172aa04c8365a7ab9a2a5c5fe9f331b"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e603fa4833d8eddb0a15e21dbbf50abff2d0331353ea50f99f96a9b8ab037c0"
    sha256 cellar: :any_skip_relocation, ventura:        "e6fbe66a4e267beaab57e630458cea4c9d544edbf1296bec4f94d64ca6fc8950"
    sha256 cellar: :any_skip_relocation, monterey:       "14734809f7e4bbc076d17abca854830de3b1889c401a2820cf797b3a69624265"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68be5fe3f942dacee01510dbbe85ad382eab719304a8ddc129b87e06bca84f47"
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