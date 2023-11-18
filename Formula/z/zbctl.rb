class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.3.3",
      revision: "c5abe400e2cd4711a1e3e05c94a43f7fd7ed1827"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0189c694353625583be64c611012997387c12ada3940d2908d46a17a683cdb69"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0189c694353625583be64c611012997387c12ada3940d2908d46a17a683cdb69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0189c694353625583be64c611012997387c12ada3940d2908d46a17a683cdb69"
    sha256 cellar: :any_skip_relocation, sonoma:         "f42ae76c0fb11f0c7ca489a7e63241ea8c79cf70c84f4d950c912350bbff7c4d"
    sha256 cellar: :any_skip_relocation, ventura:        "f42ae76c0fb11f0c7ca489a7e63241ea8c79cf70c84f4d950c912350bbff7c4d"
    sha256 cellar: :any_skip_relocation, monterey:       "f42ae76c0fb11f0c7ca489a7e63241ea8c79cf70c84f4d950c912350bbff7c4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bebec10091f7bc51b3b16613229d6fa8eb9567025e113e2a1fa23846d222628"
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
      "desc = \"transport: Error while dialing: dial tcp 127.0.0.1:26500: connect: connection refused\""
    output = shell_output("#{bin}/zbctl status 2>&1", 1)
    assert_match status_error_message, output
    # Check version
    commit = stable.specs[:revision][0..7]
    expected_version = "zbctl #{version} (commit: #{commit})"
    assert_match expected_version, shell_output("#{bin}/zbctl version")
  end
end