class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.131",
      revision: "d569adefc7b5c4f87e18be4529dc3e2199364a06"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61c7b7ba9e0202b2a7e0c0db43955562f273921e330d5d5537b6041d9aa20104"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61c7b7ba9e0202b2a7e0c0db43955562f273921e330d5d5537b6041d9aa20104"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61c7b7ba9e0202b2a7e0c0db43955562f273921e330d5d5537b6041d9aa20104"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa15f45bcf216f60ae31636ee51836362b5f62a2e7a57b7d765d34e69ef67887"
    sha256 cellar: :any_skip_relocation, ventura:       "fa15f45bcf216f60ae31636ee51836362b5f62a2e7a57b7d765d34e69ef67887"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25de1c96adc3baaa6e9a90cadda0ed1562b1667f2761bd562c2b10cd991fdf3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "800a4a10be2f8e94adcc54a8d44221bffc156cfcb2f0ff4167633cf82cd64904"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags:), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end