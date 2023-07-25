class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.111",
      revision: "b3791efac015758b1d2f3af4a61164ef2e55cd3c"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3fef4aa17533a5347ad49731dab7ca0acdb123198e692bf687de284d06d6234"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3fef4aa17533a5347ad49731dab7ca0acdb123198e692bf687de284d06d6234"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3fef4aa17533a5347ad49731dab7ca0acdb123198e692bf687de284d06d6234"
    sha256 cellar: :any_skip_relocation, ventura:        "cde8bc131a60480475d5a3a0d628eaca1f612cbbf6d3b5dd8c2dcb6570bedffc"
    sha256 cellar: :any_skip_relocation, monterey:       "cde8bc131a60480475d5a3a0d628eaca1f612cbbf6d3b5dd8c2dcb6570bedffc"
    sha256 cellar: :any_skip_relocation, big_sur:        "cde8bc131a60480475d5a3a0d628eaca1f612cbbf6d3b5dd8c2dcb6570bedffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4be967d8339607ec04e466eaf25025e1e081e3928c91070f23e99d87656057f7"
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