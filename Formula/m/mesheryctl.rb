class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.163",
      revision: "e031108e4f766b4040f15586109f82cd6c1596e0"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5e2b3e34d3dd71ba8f0f246b3826fee5b0a69109eae739fa9e27745eed5716e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5e2b3e34d3dd71ba8f0f246b3826fee5b0a69109eae739fa9e27745eed5716e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5e2b3e34d3dd71ba8f0f246b3826fee5b0a69109eae739fa9e27745eed5716e"
    sha256 cellar: :any_skip_relocation, sonoma:         "2699f9fd7a69c5eda838d9ee1fa98cdcd9bd2c017b316b146ba8d25e86bffb20"
    sha256 cellar: :any_skip_relocation, ventura:        "2699f9fd7a69c5eda838d9ee1fa98cdcd9bd2c017b316b146ba8d25e86bffb20"
    sha256 cellar: :any_skip_relocation, monterey:       "2699f9fd7a69c5eda838d9ee1fa98cdcd9bd2c017b316b146ba8d25e86bffb20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a18f020f71bc8083b47390bad338998a27316e686d3cf729db223c310b7ccf08"
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