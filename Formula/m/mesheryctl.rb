class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.25",
      revision: "aa7c4814e64087cc69dc805d9c1540b6d5e90547"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c1f903a42117b8e3a320b639dba3a5c4fdcb1efe831307f547f810dfb386f13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c1f903a42117b8e3a320b639dba3a5c4fdcb1efe831307f547f810dfb386f13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c1f903a42117b8e3a320b639dba3a5c4fdcb1efe831307f547f810dfb386f13"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc9cd8f86fa70043edce47d2d3e6cf558ec54c661f9bd8377eb9aaec2a8f0438"
    sha256 cellar: :any_skip_relocation, ventura:       "dc9cd8f86fa70043edce47d2d3e6cf558ec54c661f9bd8377eb9aaec2a8f0438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "176ddb3257d1ae023d484ffaee17fa35cbbf590ccca5d2ab59f34750e735a936"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.comlayer5iomesherymesheryctlinternalclirootconstants.version=v#{version}
      -X github.comlayer5iomesherymesheryctlinternalclirootconstants.commitsha=#{Utils.git_short_head}
      -X github.comlayer5iomesherymesheryctlinternalclirootconstants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags:), ".mesheryctlcmdmesheryctl"

    generate_completions_from_executable(bin"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}mesheryctl system start 2>&1", 1)
  end
end