class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.2.8",
      revision: "3628a8f1f24e48b100e9b6531645d73a4846c12e"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c488c80d2d4281faed47710a0a2b82036f79bf43b5bc3d495ed31fd7c4fff69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c488c80d2d4281faed47710a0a2b82036f79bf43b5bc3d495ed31fd7c4fff69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c488c80d2d4281faed47710a0a2b82036f79bf43b5bc3d495ed31fd7c4fff69"
    sha256 cellar: :any_skip_relocation, ventura:        "21e6473a281864d5b505ff230893f17e7de9eacaee85f27288132628e8ff7947"
    sha256 cellar: :any_skip_relocation, monterey:       "21e6473a281864d5b505ff230893f17e7de9eacaee85f27288132628e8ff7947"
    sha256 cellar: :any_skip_relocation, big_sur:        "21e6473a281864d5b505ff230893f17e7de9eacaee85f27288132628e8ff7947"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2ff2d76f608e4e6deb8f0128d19246d9ba8552aa90b8577618c6295c135c43b"
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