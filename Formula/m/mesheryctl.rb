class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.157",
      revision: "e93d3b65958620316ac6a4d2c6aa94f7637ad7b6"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bb59c23e0e28473b185744c7a62882082c5e75d8ee3261249cdc16069e7f3d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bb59c23e0e28473b185744c7a62882082c5e75d8ee3261249cdc16069e7f3d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "98b1aceaa0118870dc49c8b356790925182a3c133000f3d0ab359775256f29cc"
    sha256 cellar: :any_skip_relocation, ventura:        "98b1aceaa0118870dc49c8b356790925182a3c133000f3d0ab359775256f29cc"
    sha256 cellar: :any_skip_relocation, monterey:       "98b1aceaa0118870dc49c8b356790925182a3c133000f3d0ab359775256f29cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40435557c34b06943b8f0638c39b57b76638be4f76b8c814a61a13782d90cc0e"
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