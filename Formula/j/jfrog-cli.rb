class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.49.0.tar.gz"
  sha256 "b4d225beb547a0d5252935784e2f5b36c2275d5c6e54ac2ab3c7e110b77d0560"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0a1e1ed5073835c2b5f108ec2f18c9f011388e2a88a742b9b3bf8b856bba89a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e40c1b4cea53dc728a488cec763d5092bf7a7a7f630e14248ae7359052376927"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e844020239b77718dcc1d1de241c9738bbd549d3a6e19582f5dc976c26072e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "43aa73aacfc38f243977cafe0536f59eec3b8f7cbb59476ae4ea7654d3fb7ca6"
    sha256 cellar: :any_skip_relocation, ventura:        "8bed4025c9bf52459d08da57bbeccb50bcbe413e3bd0d0369ab128e86c17c272"
    sha256 cellar: :any_skip_relocation, monterey:       "3c04e161a4b1912ce969fe2b604d4b6327e8dba515ba1b3055330bbb22c5f714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "724dd057417937ce037ceb71a59ddabdeb46678a9fca97da65254d92aea85e31"
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