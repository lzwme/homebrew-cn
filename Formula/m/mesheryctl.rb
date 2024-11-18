class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.153",
      revision: "f9fe1ebdb1ceea15b9920dc29dece04de91dd5b0"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "003f9b2a6b6a8a58b82cb24c075243e104030a5c33ea9e345bb91c3d99b35f72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "003f9b2a6b6a8a58b82cb24c075243e104030a5c33ea9e345bb91c3d99b35f72"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "003f9b2a6b6a8a58b82cb24c075243e104030a5c33ea9e345bb91c3d99b35f72"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d358386095a339a8a8bd65701f7d8bdd6b565b90e3dd2d44e84478c21f5df77"
    sha256 cellar: :any_skip_relocation, ventura:       "7d358386095a339a8a8bd65701f7d8bdd6b565b90e3dd2d44e84478c21f5df77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3c269a5f048f2ff5ce016a6cd3159428bcce83f7f7912949f7505559a08f21d"
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