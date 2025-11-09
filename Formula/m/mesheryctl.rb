class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.156",
      revision: "de65b5ce39a55f9c308178d8205db7851a9a7f26"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ade80e90792442c5211a91f110869313c3b002dc33c1c1831b4c6e6de9f016d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ade80e90792442c5211a91f110869313c3b002dc33c1c1831b4c6e6de9f016d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ade80e90792442c5211a91f110869313c3b002dc33c1c1831b4c6e6de9f016d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe9b1f6f91c1dbbe52517a1a6c9cab8420ace8b83ece577e2a15ffd4f83b4753"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13b3105fb769ffbac08a5fcc8f8ec4697149b3476fdb5cefd9260ee72003f58d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33c68b4a4fa925c5ce6cab155c1dd1d8bf91147fb5f64f63c2c3e4774f672698"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

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