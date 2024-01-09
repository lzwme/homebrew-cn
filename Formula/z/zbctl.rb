class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https:docs.camunda.iodocsapis-clientscli-clientindex"
  url "https:github.comcamundazeebe.git",
      tag:      "8.4.0",
      revision: "c59d24240d3c44a083f35ab315583f7f9724a337"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b69c090ebb0620887259fd0d5317dd72c1bd4084f95de4858f3e669e1822c7cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b69c090ebb0620887259fd0d5317dd72c1bd4084f95de4858f3e669e1822c7cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b69c090ebb0620887259fd0d5317dd72c1bd4084f95de4858f3e669e1822c7cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "72bbdf3f566981cadd364f52bb94edf5fd47a533f5599bb68a373e12931a89ea"
    sha256 cellar: :any_skip_relocation, ventura:        "72bbdf3f566981cadd364f52bb94edf5fd47a533f5599bb68a373e12931a89ea"
    sha256 cellar: :any_skip_relocation, monterey:       "72bbdf3f566981cadd364f52bb94edf5fd47a533f5599bb68a373e12931a89ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9558906f9fa095c53313cea13d27112375324d2f21a6c326ddccc572bf4e8cd7"
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