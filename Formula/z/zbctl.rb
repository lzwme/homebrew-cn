class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.3.2",
      revision: "e60a54fd99e3bb3780e8f7b17050d7141e0566de"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d94bd2a256f1ce3033db51d429180bf52e3df58a847b6af5749680963d4d5935"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d94bd2a256f1ce3033db51d429180bf52e3df58a847b6af5749680963d4d5935"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d94bd2a256f1ce3033db51d429180bf52e3df58a847b6af5749680963d4d5935"
    sha256 cellar: :any_skip_relocation, sonoma:         "b097641b2e370a8e62a34b191b6aaeb5ba26f4b868a0f76027bbba6b0b5d54e2"
    sha256 cellar: :any_skip_relocation, ventura:        "b097641b2e370a8e62a34b191b6aaeb5ba26f4b868a0f76027bbba6b0b5d54e2"
    sha256 cellar: :any_skip_relocation, monterey:       "b097641b2e370a8e62a34b191b6aaeb5ba26f4b868a0f76027bbba6b0b5d54e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17fd88597286f8da171a0139b4f61deed42afd15bd1e53b4ef63cb531d60d79a"
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