class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.119",
      revision: "43032c027403cb8b4a4cce4a3d16eaef3a2157d3"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f086cba44799f268e6a897c6dad6e7349d264b472608457f078586a4f0988135"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f086cba44799f268e6a897c6dad6e7349d264b472608457f078586a4f0988135"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f086cba44799f268e6a897c6dad6e7349d264b472608457f078586a4f0988135"
    sha256 cellar: :any_skip_relocation, ventura:        "4a5a444899c8eecc9c998794535a3963d15ce88d136d2735f9ff7988140352f2"
    sha256 cellar: :any_skip_relocation, monterey:       "4a5a444899c8eecc9c998794535a3963d15ce88d136d2735f9ff7988140352f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a5a444899c8eecc9c998794535a3963d15ce88d136d2735f9ff7988140352f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "264a218f1e8856375ecfd56aec57de49e0cb5f02988aa37ea6e7f8130b38be00"
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