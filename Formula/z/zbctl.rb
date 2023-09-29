class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.2.15",
      revision: "393b02d6a53edbcca5aa4780cae8590a58cb5e47"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be4233d66fdd7d4694c13e7b3ccbe1e02c9e80e8dd75039838238501d327cc77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be4233d66fdd7d4694c13e7b3ccbe1e02c9e80e8dd75039838238501d327cc77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be4233d66fdd7d4694c13e7b3ccbe1e02c9e80e8dd75039838238501d327cc77"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1b3df55bb1067bff0a00183d2e1991b262e7f20d0db62d724a86dd7b78926a6"
    sha256 cellar: :any_skip_relocation, ventura:        "b1b3df55bb1067bff0a00183d2e1991b262e7f20d0db62d724a86dd7b78926a6"
    sha256 cellar: :any_skip_relocation, monterey:       "b1b3df55bb1067bff0a00183d2e1991b262e7f20d0db62d724a86dd7b78926a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed81b8a314001713e9d218dabaf976094220ac8d84e0c746531029e987c37f92"
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