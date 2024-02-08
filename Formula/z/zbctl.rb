class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https:docs.camunda.iodocsapis-clientscli-clientindex"
  url "https:github.comcamundazeebe.git",
      tag:      "8.4.2",
      revision: "0af449cbeef639186708eb6d72c5876f9a2d2c15"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "377daddbc53fe11c9826bd2517a3074a94f38d71857fa6ecee11d986f58b378f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "377daddbc53fe11c9826bd2517a3074a94f38d71857fa6ecee11d986f58b378f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "377daddbc53fe11c9826bd2517a3074a94f38d71857fa6ecee11d986f58b378f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c98c6a052ccf1ea464be3e5575aa3591658f0bbdca54602a65a0fe8ff2980ed7"
    sha256 cellar: :any_skip_relocation, ventura:        "c98c6a052ccf1ea464be3e5575aa3591658f0bbdca54602a65a0fe8ff2980ed7"
    sha256 cellar: :any_skip_relocation, monterey:       "c98c6a052ccf1ea464be3e5575aa3591658f0bbdca54602a65a0fe8ff2980ed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75d4d63d7cea8afc2e53f40899e90a4106bb2a3a7151687fde9663b81604b9df"
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