class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.2.1",
      revision: "2bb1d6c53f287caa9b4b30f1cf6cd703fe4a4dc1"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46fdbb5c1b7014b1afd52bc9a95241700ebc6cd3d5eeee470489d2a3a0f92819"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46fdbb5c1b7014b1afd52bc9a95241700ebc6cd3d5eeee470489d2a3a0f92819"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46fdbb5c1b7014b1afd52bc9a95241700ebc6cd3d5eeee470489d2a3a0f92819"
    sha256 cellar: :any_skip_relocation, ventura:        "a29763e0aea2efa3fe97d7bd4c718b17542d80c031636a84958c1c36b978616c"
    sha256 cellar: :any_skip_relocation, monterey:       "a29763e0aea2efa3fe97d7bd4c718b17542d80c031636a84958c1c36b978616c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a29763e0aea2efa3fe97d7bd4c718b17542d80c031636a84958c1c36b978616c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09518362d8f2bd86532189e15ba3b8f7f89061d266a2b46d621035e9e9e9e0a8"
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