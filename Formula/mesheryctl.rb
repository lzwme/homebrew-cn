class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.76",
      revision: "fc58e64b076598df3eb9972677c0aff23e26c9f7"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cb25df2527874e5ef6e9f454b27cced4f4da2eb2e97c861fe7737a0a093193f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "926e6ad0651bfd1ffcb05e5cdabcf77f008a62ea585f0dfdc31cc5946a353ac6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4cb25df2527874e5ef6e9f454b27cced4f4da2eb2e97c861fe7737a0a093193f"
    sha256 cellar: :any_skip_relocation, ventura:        "03310d1c9c8552c706fca61ecd481274688ec26e852347e63fed72f763405177"
    sha256 cellar: :any_skip_relocation, monterey:       "03310d1c9c8552c706fca61ecd481274688ec26e852347e63fed72f763405177"
    sha256 cellar: :any_skip_relocation, big_sur:        "03310d1c9c8552c706fca61ecd481274688ec26e852347e63fed72f763405177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a97b04f556a50a04b301b3a5518ec6abd34b4e01f2538e5afa9dc98077fbf056"
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