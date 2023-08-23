class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.131",
      revision: "520707ea15d4b2e1cedfaa6b61144abee7fb012a"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c21376aba9f3ec4d50aa7e09140a1963dc4f795a790604dfaf6733488262fb26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c21376aba9f3ec4d50aa7e09140a1963dc4f795a790604dfaf6733488262fb26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c21376aba9f3ec4d50aa7e09140a1963dc4f795a790604dfaf6733488262fb26"
    sha256 cellar: :any_skip_relocation, ventura:        "2601fe02f924e2a1ac6cdfac3628be286d1702c54846e6d8172f66b9d3410f1a"
    sha256 cellar: :any_skip_relocation, monterey:       "2601fe02f924e2a1ac6cdfac3628be286d1702c54846e6d8172f66b9d3410f1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2601fe02f924e2a1ac6cdfac3628be286d1702c54846e6d8172f66b9d3410f1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28f09ddbcb795a74c80a4590bae836d4326f4ca4e0bc3ce7347f4555ac297258"
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