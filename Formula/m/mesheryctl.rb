class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.161",
      revision: "f4a050de45f19521c7a59e49cde58cb63e979ce0"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e147d1034e8d0ea792c693342f8eb4ff0380421577dab881c578353846370b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e147d1034e8d0ea792c693342f8eb4ff0380421577dab881c578353846370b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e147d1034e8d0ea792c693342f8eb4ff0380421577dab881c578353846370b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "83005ba86d2b900a4145b0d6fa371fa0d9bfb8523ce2cf6e9c20f9454ea66b7f"
    sha256 cellar: :any_skip_relocation, ventura:        "83005ba86d2b900a4145b0d6fa371fa0d9bfb8523ce2cf6e9c20f9454ea66b7f"
    sha256 cellar: :any_skip_relocation, monterey:       "83005ba86d2b900a4145b0d6fa371fa0d9bfb8523ce2cf6e9c20f9454ea66b7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a34cf3579a91757c160399ae5f94ff4206ae7666b728074c5d29f9c3d87152b"
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