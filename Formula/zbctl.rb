class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.2.4",
      revision: "eb30999225581a7921ed20ba9c1706f8d32c1449"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0731d9f6c5eac8099d07af01b564ec2c5172464cd4daac72a2a59b11c767dac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0731d9f6c5eac8099d07af01b564ec2c5172464cd4daac72a2a59b11c767dac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0731d9f6c5eac8099d07af01b564ec2c5172464cd4daac72a2a59b11c767dac"
    sha256 cellar: :any_skip_relocation, ventura:        "0008699c626ee94ead455f30abcc4010414236e8e5cff23b000bde8717ff92ba"
    sha256 cellar: :any_skip_relocation, monterey:       "0008699c626ee94ead455f30abcc4010414236e8e5cff23b000bde8717ff92ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "0008699c626ee94ead455f30abcc4010414236e8e5cff23b000bde8717ff92ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea7cb3c7922e742bbd89f5841d5de220bab38777d58b650e2d0668674bc60b2f"
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