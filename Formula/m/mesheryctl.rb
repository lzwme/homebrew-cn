class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.153",
      revision: "34662e04cc0752eb2e777863ad202edb7888ab33"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60addb04a16dead7fbcc25fa40dd70d226a8ab68265a8fa246f096dd6d23ea88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60addb04a16dead7fbcc25fa40dd70d226a8ab68265a8fa246f096dd6d23ea88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60addb04a16dead7fbcc25fa40dd70d226a8ab68265a8fa246f096dd6d23ea88"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d3a27abbc7e9292f3a19b7dd8b00a957fa607008df07bad7242d8b1bd0aaed6"
    sha256 cellar: :any_skip_relocation, ventura:        "4d3a27abbc7e9292f3a19b7dd8b00a957fa607008df07bad7242d8b1bd0aaed6"
    sha256 cellar: :any_skip_relocation, monterey:       "4d3a27abbc7e9292f3a19b7dd8b00a957fa607008df07bad7242d8b1bd0aaed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d68e5004e0f4147a2a0af86a3d69812764a91cf909f8f7c9365f15de5d82552"
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