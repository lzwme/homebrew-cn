class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.139",
      revision: "77703b11b85a855e7ec660c7b44c945da735cbb7"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa3f39abea515ebdc7350ff2056b9f49dd84f7b1351141766b24836725414e70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa3f39abea515ebdc7350ff2056b9f49dd84f7b1351141766b24836725414e70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa3f39abea515ebdc7350ff2056b9f49dd84f7b1351141766b24836725414e70"
    sha256 cellar: :any_skip_relocation, ventura:        "a494866d58a63070b3688d24d8b034c55138e981fb45d00a28683ca47499a659"
    sha256 cellar: :any_skip_relocation, monterey:       "a494866d58a63070b3688d24d8b034c55138e981fb45d00a28683ca47499a659"
    sha256 cellar: :any_skip_relocation, big_sur:        "a494866d58a63070b3688d24d8b034c55138e981fb45d00a28683ca47499a659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23bdc2d2fbd9e0fbbb6ffb240121fa9e91db94ff786e1dc30f4bd9918ebc410f"
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