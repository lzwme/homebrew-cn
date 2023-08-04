class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.116",
      revision: "511b8d06a2e392e115d6aa21d5dc3a7a72604b31"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3753addafdbda227c5b28c0821fe3ca2648345ae6a536871b67ed4135ae82be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3753addafdbda227c5b28c0821fe3ca2648345ae6a536871b67ed4135ae82be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3753addafdbda227c5b28c0821fe3ca2648345ae6a536871b67ed4135ae82be"
    sha256 cellar: :any_skip_relocation, ventura:        "487291aef5a552b81154b587830ef4fbd8e8aaa8a20748ecfd3e266ca969f9ab"
    sha256 cellar: :any_skip_relocation, monterey:       "487291aef5a552b81154b587830ef4fbd8e8aaa8a20748ecfd3e266ca969f9ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "487291aef5a552b81154b587830ef4fbd8e8aaa8a20748ecfd3e266ca969f9ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d4ec8544db0bc56df51655368ff16c77ac3e2893ecf09961f9917fa8f093ccb"
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