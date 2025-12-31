class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.193",
      revision: "2104b923db80896e8d201a3508847b53a9f0f323"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "739f5ef9e59873e5ae1fde1f470f8181fa3fbcb344cb24bfb5829d09e77584b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f14c823431c27aabe5bc90a3715dea25d97a1cf16935ca60cdb223571044a672"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1786122858be935f15965eeb9de41e56420c77ed8cc0ba1566fab17a7315595"
    sha256 cellar: :any_skip_relocation, sonoma:        "46fffd93c35d8ae6758cd8f414bb4d9ca7937b7cae5eb34b56a311c73847ba57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9bd9ece5d2555da0c6c84e98125bb28d9ecb0fd18df2b1df8c3db478165418d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e328dc675b7fc8c7b1860fb37636b70e0f26fde1f99925f9930403d23003a1a6"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

    ldflags = %W[
      -s -w
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags:), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end