class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.3.1",
      revision: "d98e405e72752592b5a0adf66dbf2e076b473c6d"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34cda96bcfaa66f0e128509eb39794ff8be5cd8a02b39d57d6480d1628c0788a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34cda96bcfaa66f0e128509eb39794ff8be5cd8a02b39d57d6480d1628c0788a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34cda96bcfaa66f0e128509eb39794ff8be5cd8a02b39d57d6480d1628c0788a"
    sha256 cellar: :any_skip_relocation, sonoma:         "99dfc2492292b00d3de33e3c5e3f022a7bbde6fba82d28a944f31f0c3b17cca5"
    sha256 cellar: :any_skip_relocation, ventura:        "99dfc2492292b00d3de33e3c5e3f022a7bbde6fba82d28a944f31f0c3b17cca5"
    sha256 cellar: :any_skip_relocation, monterey:       "99dfc2492292b00d3de33e3c5e3f022a7bbde6fba82d28a944f31f0c3b17cca5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f065ba267cf44aa5d26770b75d237018c99eb09a6f03e8d2c3e1024c24e1cc5a"
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