class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.2.2",
      revision: "82eaf53f0ba88fea0c60a046498f705424e0c634"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d7a2c3a386c3c2a2d7b809c998753496008a400366c989e175c28beae10a68d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d7a2c3a386c3c2a2d7b809c998753496008a400366c989e175c28beae10a68d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d7a2c3a386c3c2a2d7b809c998753496008a400366c989e175c28beae10a68d"
    sha256 cellar: :any_skip_relocation, ventura:        "99a597b1f1cbfe4bd3427bda453e86f285559335d123197b0b63f0b0d2dbc33b"
    sha256 cellar: :any_skip_relocation, monterey:       "99a597b1f1cbfe4bd3427bda453e86f285559335d123197b0b63f0b0d2dbc33b"
    sha256 cellar: :any_skip_relocation, big_sur:        "99a597b1f1cbfe4bd3427bda453e86f285559335d123197b0b63f0b0d2dbc33b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d0d51b5d2bd6dead7434932a93c3091751815126b4ceb63245be4bfb9283301"
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