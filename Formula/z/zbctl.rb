class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https:docs.camunda.iodocsapis-clientscli-clientindex"
  url "https:github.comcamundazeebe.git",
      tag:      "8.4.4",
      revision: "a03f0d262aa4e2b19f04bea0b6bd4795b052de6f"
  license "Apache-2.0"
  head "https:github.comcamundazeebe.git", branch: "develop"

  # Upstream creates stable version tags (e.g., `v1.2.3`) before a release but
  # the version isn't considered to be released until a corresponding release
  # is created on GitHub, so it's necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd7ef19bbccbd08a4d8dd933edef7cb9cb61bbf26f0dc0c0fc9e6d3c89402279"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd7ef19bbccbd08a4d8dd933edef7cb9cb61bbf26f0dc0c0fc9e6d3c89402279"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd7ef19bbccbd08a4d8dd933edef7cb9cb61bbf26f0dc0c0fc9e6d3c89402279"
    sha256 cellar: :any_skip_relocation, sonoma:         "d0fa0c958c39e078b760203f090877c315a9bb17283757afe484070825f5b920"
    sha256 cellar: :any_skip_relocation, ventura:        "d0fa0c958c39e078b760203f090877c315a9bb17283757afe484070825f5b920"
    sha256 cellar: :any_skip_relocation, monterey:       "d0fa0c958c39e078b760203f090877c315a9bb17283757afe484070825f5b920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd519dede0ad01afe831f9cfc591bb8a2cfac79d039eecdc40cb6217d2545e76"
  end

  depends_on "go" => :build

  def install
    commit = Utils.git_short_head
    chdir "clientsgocmdzbctl" do
      project = "github.comcamundazeebeclientsgov8cmdzbctlinternalcommands"
      ldflags = %W[
        -w
        -X #{project}.Version=#{version}
        -X #{project}.Commit=#{commit}
      ]
      system "go", "build", "-tags", "netgo", *std_go_args(ldflags: ldflags)

      generate_completions_from_executable(bin"zbctl", "completion")
    end
  end

  test do
    # Check status for a nonexistent cluster
    status_error_message =
      "Error: rpc error: code = " \
      "Unavailable desc = connection error: " \
      "desc = \"transport: Error while dialing: dial tcp 127.0.0.1:26500: connect: connection refused\""
    output = shell_output("#{bin}zbctl status 2>&1", 1)
    assert_match status_error_message, output
    # Check version
    commit = stable.specs[:revision][0..7]
    expected_version = "zbctl #{version} (commit: #{commit})"
    assert_match expected_version, shell_output("#{bin}zbctl version")
  end
end