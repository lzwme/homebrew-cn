class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.37.0.tar.gz"
  sha256 "7b4bd95bae0d71d380e9a0250890c1bccd0db2ad480a74da31b02ab1b90d1fe3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89ae87e796c8d5349912cfc3d3a985bb03f587c8fecae383a83831ece155dc90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89ae87e796c8d5349912cfc3d3a985bb03f587c8fecae383a83831ece155dc90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89ae87e796c8d5349912cfc3d3a985bb03f587c8fecae383a83831ece155dc90"
    sha256 cellar: :any_skip_relocation, ventura:        "d13b828146b205af8d31b6c5169912bec784190f2aa973c99e71c9bba8ec58de"
    sha256 cellar: :any_skip_relocation, monterey:       "d13b828146b205af8d31b6c5169912bec784190f2aa973c99e71c9bba8ec58de"
    sha256 cellar: :any_skip_relocation, big_sur:        "d13b828146b205af8d31b6c5169912bec784190f2aa973c99e71c9bba8ec58de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79e60526f9feea0dddf815abf65bccc2aac6d7a516780bdad7ce2bc255b888f7"
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