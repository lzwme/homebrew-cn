class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.148",
      revision: "ab6b438aa50adbea18afa5f58ef67af056456880"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a92c35cf09060bf2ceeb67fca14491fc576089ec838bb90eff6eb3741c3f49a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a92c35cf09060bf2ceeb67fca14491fc576089ec838bb90eff6eb3741c3f49a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a92c35cf09060bf2ceeb67fca14491fc576089ec838bb90eff6eb3741c3f49a"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc476e686259d5d9668383450322cbcb5b7c270b96a252fb7cc0e15676f5c248"
    sha256 cellar: :any_skip_relocation, ventura:        "dc476e686259d5d9668383450322cbcb5b7c270b96a252fb7cc0e15676f5c248"
    sha256 cellar: :any_skip_relocation, monterey:       "dc476e686259d5d9668383450322cbcb5b7c270b96a252fb7cc0e15676f5c248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0df28674d584ff9c1e92b3da828d29a6fd6d2d3f0e8da2ada7f5fa5bb7214e4"
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