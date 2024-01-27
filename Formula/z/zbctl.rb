class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https:docs.camunda.iodocsapis-clientscli-clientindex"
  url "https:github.comcamundazeebe.git",
      tag:      "8.4.1",
      revision: "9b2059f6e3439f4642d49a1195c5a4c267861c98"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "309e1eaf0a60e200e3e82f76af648aa74c3ab60aaa182556abede09a709989c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "309e1eaf0a60e200e3e82f76af648aa74c3ab60aaa182556abede09a709989c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "309e1eaf0a60e200e3e82f76af648aa74c3ab60aaa182556abede09a709989c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "88daccbbe871820f788fe6124e5c3126a7e768c36cfaec2fdb62bdbb12b43ffe"
    sha256 cellar: :any_skip_relocation, ventura:        "88daccbbe871820f788fe6124e5c3126a7e768c36cfaec2fdb62bdbb12b43ffe"
    sha256 cellar: :any_skip_relocation, monterey:       "88daccbbe871820f788fe6124e5c3126a7e768c36cfaec2fdb62bdbb12b43ffe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f5e87def2b515c35f2550dc7649850e03112699f1fecfbc5438669259a5f83c"
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