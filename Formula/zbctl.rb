class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.2.10",
      revision: "123639f566c1e52b9e5e7b659a6945584d775b3e"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "639bdc0bb3b9a835f20c8d797f57aa4f35f0fd26a926f44908c7ded8044ff981"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "639bdc0bb3b9a835f20c8d797f57aa4f35f0fd26a926f44908c7ded8044ff981"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "639bdc0bb3b9a835f20c8d797f57aa4f35f0fd26a926f44908c7ded8044ff981"
    sha256 cellar: :any_skip_relocation, ventura:        "ad46f4c2d13adb2206c014feef973077fae1573c4b8fedc79ea9be5d1a8d7fb4"
    sha256 cellar: :any_skip_relocation, monterey:       "ad46f4c2d13adb2206c014feef973077fae1573c4b8fedc79ea9be5d1a8d7fb4"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad46f4c2d13adb2206c014feef973077fae1573c4b8fedc79ea9be5d1a8d7fb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1739843e9fb8b1c79305c8135d40807f9d1b54d0e5e4d3a6de19577fdbf2cac"
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