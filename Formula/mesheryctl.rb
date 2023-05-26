class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.89",
      revision: "b1ee531c06d94c1becf9ff2785f44f4c1bfc02a2"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe04318106c8207c18dd4d1896417e7f13e3d9b8f2b528a33fd99dbe1e6b40cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe04318106c8207c18dd4d1896417e7f13e3d9b8f2b528a33fd99dbe1e6b40cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe04318106c8207c18dd4d1896417e7f13e3d9b8f2b528a33fd99dbe1e6b40cd"
    sha256 cellar: :any_skip_relocation, ventura:        "c81d5595fca94f228d1746a57b24ec5b9c84089206bdbf0f2fbb3f7f3464b779"
    sha256 cellar: :any_skip_relocation, monterey:       "c81d5595fca94f228d1746a57b24ec5b9c84089206bdbf0f2fbb3f7f3464b779"
    sha256 cellar: :any_skip_relocation, big_sur:        "c81d5595fca94f228d1746a57b24ec5b9c84089206bdbf0f2fbb3f7f3464b779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11107fb84239560d7d38b293ba5deb27a811a0e797cf8098e8a9461322dbf48b"
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