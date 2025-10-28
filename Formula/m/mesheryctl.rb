class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.144",
      revision: "302c846f9db92d0f8e503a95b801f5e2d3305981"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fd9453151dbca6c09f0044cacf72b9cbfeb2533e03b3a2e8cfbf902d48144fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fd9453151dbca6c09f0044cacf72b9cbfeb2533e03b3a2e8cfbf902d48144fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fd9453151dbca6c09f0044cacf72b9cbfeb2533e03b3a2e8cfbf902d48144fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "05a20600f8b461689515d8c9d971f0c15275183eb02901b2505c623daf514c4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbdceafe218c5583168b5f93fb9e5ae1261443a433972fba480df183502249a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca7b22a39a78282b76bf2d11f237138a0f7caec47fa5f6dae8e264f80c200103"
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