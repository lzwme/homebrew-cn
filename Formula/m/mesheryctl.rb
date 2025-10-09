class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.136",
      revision: "75694b531375217f14bfb3c1d9d866fbd42a9b08"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f476b1aea2f9ed6c2371ba020e06f7f0a373f0c549e4fa257e14b3f3db84ba2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f476b1aea2f9ed6c2371ba020e06f7f0a373f0c549e4fa257e14b3f3db84ba2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f476b1aea2f9ed6c2371ba020e06f7f0a373f0c549e4fa257e14b3f3db84ba2"
    sha256 cellar: :any_skip_relocation, sonoma:        "df407dd0546aaf782bf184458b540a90a78a0c1534b18e18be93bf929d5bbd02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb4e38319137530a5a0278591ee648f9aae9ee13676264d76bf7675bd7557cfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e05e30944d6a23659731b851f9395a1b213476ef0347d197239fec93a59be37"
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