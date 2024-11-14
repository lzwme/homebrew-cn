class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.71.4.tar.gz"
  sha256 "d63ad3025f21a04095269237a693a2e83bfbbc17840febdb2be1ad751fd04838"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af4c0eea5d2d4496b7d0d4166f62ea54f95d95522145ae86918e6d11b62bdaf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af4c0eea5d2d4496b7d0d4166f62ea54f95d95522145ae86918e6d11b62bdaf9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af4c0eea5d2d4496b7d0d4166f62ea54f95d95522145ae86918e6d11b62bdaf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b56e017cc4f201f32b8682c57d8e10c65867882146056431bdda577bce38fab"
    sha256 cellar: :any_skip_relocation, ventura:       "4b56e017cc4f201f32b8682c57d8e10c65867882146056431bdda577bce38fab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "958ce182782473ca8692f52ff1ab512f7943988c0cee07410ea9ca1a36f1e954"
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