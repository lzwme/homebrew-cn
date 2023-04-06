class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.2.0",
      revision: "f2bbc3eabe44adebba354f1c0a2987e4163e0681"
  license "Apache-2.0"
  head "https://github.com/camunda/zeebe.git", branch: "develop"

  # Upstream creates stable version tags (e.g., `v1.2.3`) before a release but
  # the version isn't considered to be released until a corresponding release
  # is created on GitHub, so it's necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a689e385030c3b8c71a196a4adb002ca6ae4371e694a7fbf5993a328f191c75c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a689e385030c3b8c71a196a4adb002ca6ae4371e694a7fbf5993a328f191c75c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a689e385030c3b8c71a196a4adb002ca6ae4371e694a7fbf5993a328f191c75c"
    sha256 cellar: :any_skip_relocation, ventura:        "1595fa5cb9cdd80408c35cd6f98fa7871c3a574af81ff62321b156cdafa7192c"
    sha256 cellar: :any_skip_relocation, monterey:       "1595fa5cb9cdd80408c35cd6f98fa7871c3a574af81ff62321b156cdafa7192c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1595fa5cb9cdd80408c35cd6f98fa7871c3a574af81ff62321b156cdafa7192c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d52f2860e6cca0b6e793540f1ca3ce11ec95f7becd68aefbc0d6818e4abe8035"
  end

  depends_on "go" => :build

  def install
    commit = Utils.git_short_head
    chdir "clients/go/cmd/zbctl" do
      project = "github.com/camunda/zeebe/clients/go/v8/cmd/zbctl/internal/commands"
      ldflags = %W[
        -w
        -X #{project}.Version=#{version}
        -X #{project}.Commit=#{commit}
      ]
      system "go", "build", "-tags", "netgo", *std_go_args(ldflags: ldflags)

      generate_completions_from_executable(bin/"zbctl", "completion")
    end
  end

  test do
    # Check status for a nonexistent cluster
    status_error_message =
      "Error: rpc error: code = " \
      "Unavailable desc = connection error: " \
      "desc = \"transport: Error while dialing dial tcp 127.0.0.1:26500: connect: connection refused\""
    output = shell_output("#{bin}/zbctl status 2>&1", 1)
    assert_match status_error_message, output
    # Check version
    commit = stable.specs[:revision][0..7]
    expected_version = "zbctl #{version} (commit: #{commit})"
    assert_match expected_version, shell_output("#{bin}/zbctl version")
  end
end