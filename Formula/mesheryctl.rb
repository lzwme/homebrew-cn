class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.88",
      revision: "20e7971f3739c21989bbd7df81612d6a00d8d552"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5cf441761a5a13800957fce3203b77784508a3bd83d8dea74f70225565b542f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5cf441761a5a13800957fce3203b77784508a3bd83d8dea74f70225565b542f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5cf441761a5a13800957fce3203b77784508a3bd83d8dea74f70225565b542f"
    sha256 cellar: :any_skip_relocation, ventura:        "0cc77a9bf02b0683b1f058bb0fd042a998d6ecf532145b3def4d331bd59e4445"
    sha256 cellar: :any_skip_relocation, monterey:       "0cc77a9bf02b0683b1f058bb0fd042a998d6ecf532145b3def4d331bd59e4445"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cc77a9bf02b0683b1f058bb0fd042a998d6ecf532145b3def4d331bd59e4445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "637d1349fd4b60aed842d368f558cf1f96f4527d4385db1f4632425062914a95"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end