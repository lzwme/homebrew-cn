class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.159",
      revision: "eb5165c994da30f992f5aa27a155c7a0ee676e5e"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8253b13dee7e64d4563dc96fe1ca7940190665117dda297f7715faf443097e76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8253b13dee7e64d4563dc96fe1ca7940190665117dda297f7715faf443097e76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8253b13dee7e64d4563dc96fe1ca7940190665117dda297f7715faf443097e76"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bf82844fba93e832e9c5305bb9cb1417362eb99a78a2f63fd3ebd210643d630"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ad451caa0409ba821f0eec6c42a116214bff8c79cae6457c8413999e7624081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ab46e766dd5cb7cd43933fe8b5bcd7267d74ee2ae77cca4a112d680057b99c7"
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