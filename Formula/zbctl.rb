class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.2.9",
      revision: "8066d8065a9446c75980b4bb003677f823e0e180"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6a0ed4ee4db1285c49c59cfb1d2b930ccf6e5e52bafa99b0519a519a49df02f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6a0ed4ee4db1285c49c59cfb1d2b930ccf6e5e52bafa99b0519a519a49df02f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6a0ed4ee4db1285c49c59cfb1d2b930ccf6e5e52bafa99b0519a519a49df02f"
    sha256 cellar: :any_skip_relocation, ventura:        "ac105dbfa03153d6d0f608c26fb3b2156ecb1947f4ad64e72dbf1ecaf8b2ccfb"
    sha256 cellar: :any_skip_relocation, monterey:       "ac105dbfa03153d6d0f608c26fb3b2156ecb1947f4ad64e72dbf1ecaf8b2ccfb"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac105dbfa03153d6d0f608c26fb3b2156ecb1947f4ad64e72dbf1ecaf8b2ccfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d0dbcd96b8531870c03446ab06783109cb0d3c94977cbdc3c114ddc8694e7b8"
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