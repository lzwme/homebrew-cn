class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.127.0.tar.gz"
  sha256 "7f04e866303c714552a05f315bbeeb59692a36f2b6220ed2845b90aa2655834a"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "39742d20cdc862b66965b876bfa4a26b3562f4362e53f680437da6aaca89fd13"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "39742d20cdc862b66965b876bfa4a26b3562f4362e53f680437da6aaca89fd13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "39742d20cdc862b66965b876bfa4a26b3562f4362e53f680437da6aaca89fd13"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d6893daefc597c161e69fa80b59fd547d076087985067d33fe220fb7dfb3bdb1"
    sha256 cellar: :any,                 x86_64_linux:      "1c9c7fda71bdb0289cec68caa782705785b06bf13d8f1b60231b914b50e29d92"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion")
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