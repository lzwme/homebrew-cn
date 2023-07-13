class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.107",
      revision: "325243b1fa4f747696918aa80969235fb02a6f62"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38c2d0db1a5e65d35e8329a358e129d81c8db6937ed469af9d70df0ae2674e51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38c2d0db1a5e65d35e8329a358e129d81c8db6937ed469af9d70df0ae2674e51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38c2d0db1a5e65d35e8329a358e129d81c8db6937ed469af9d70df0ae2674e51"
    sha256 cellar: :any_skip_relocation, ventura:        "7169ce34d24f98a36b0812b8131251f09ed4d9f6808081789cf223d50cbe22f8"
    sha256 cellar: :any_skip_relocation, monterey:       "7169ce34d24f98a36b0812b8131251f09ed4d9f6808081789cf223d50cbe22f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "7169ce34d24f98a36b0812b8131251f09ed4d9f6808081789cf223d50cbe22f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c036622bac35dc8f5b170f2d982aea180dd1b0907b381e6f3f83b8fd6281d6a6"
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