class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.50.2.tar.gz"
  sha256 "f0cc4f79e47ca4ece51823f46e27f6386444a5d61ebe6dc7475e3d8e593f9027"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04b7daafe3690c2e54a60c5811a50158e926c5fe5670f5887c65a7e8b5e951d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3764c87b79cb471fafe542aa0a2abd3a76913bffc637ac6475609655f3fd5a7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf9edb8cae9a131b14047adbed953da339e71bfb6e9c6d0dbc4928518c0c7473"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e17232e3bba15b3755153a8febc43acee29304bb18f4d851e363cf689eede60"
    sha256 cellar: :any_skip_relocation, ventura:        "2c78b01cfa9c44f454da2981d1d16053fa1154aa33522a56ccc08f119b268b50"
    sha256 cellar: :any_skip_relocation, monterey:       "a56d916e8cd338b39026785a2f9c690fcf20bf216d05f6a9383d41dd2e1e4f16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e019f51bbf81b1a2018e1490ab77a157903cb1d269a39b25d6ab6f0ea40c57d3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion", base_name: "jf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1 2>&1", 1)
    end
  end
end