class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.125",
      revision: "d17317af21cdf9cef13fd94292543ba24ceb99dd"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e06b01a0a1fe6b41cabc93748e99802ca6a6a35629e9fc98c7aebb6fda23a19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e06b01a0a1fe6b41cabc93748e99802ca6a6a35629e9fc98c7aebb6fda23a19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e06b01a0a1fe6b41cabc93748e99802ca6a6a35629e9fc98c7aebb6fda23a19"
    sha256 cellar: :any_skip_relocation, ventura:        "31138745566d2c188312770bf61a39915291586c565ab1837bbd177fabf05ddc"
    sha256 cellar: :any_skip_relocation, monterey:       "31138745566d2c188312770bf61a39915291586c565ab1837bbd177fabf05ddc"
    sha256 cellar: :any_skip_relocation, big_sur:        "31138745566d2c188312770bf61a39915291586c565ab1837bbd177fabf05ddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c89853c8328bbcde1bde9c0634c008b79f5e4dce7060d6a98e40b7464ff4ebdd"
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