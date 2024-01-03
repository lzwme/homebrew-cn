class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.6",
      revision: "b7e3b69ecb4d8ab89867ec846dd73fa6d3521eec"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34f98b4d7c66bec041f9aaa09efc9fae94b4596f1f9f62000dd1ad705a157227"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34f98b4d7c66bec041f9aaa09efc9fae94b4596f1f9f62000dd1ad705a157227"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34f98b4d7c66bec041f9aaa09efc9fae94b4596f1f9f62000dd1ad705a157227"
    sha256 cellar: :any_skip_relocation, sonoma:         "f03ea85645942a5adada5d7802ba374a628a2b1b7c73e8212d359c3854f23c15"
    sha256 cellar: :any_skip_relocation, ventura:        "f03ea85645942a5adada5d7802ba374a628a2b1b7c73e8212d359c3854f23c15"
    sha256 cellar: :any_skip_relocation, monterey:       "f03ea85645942a5adada5d7802ba374a628a2b1b7c73e8212d359c3854f23c15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bcf7a1f49f07c5e5afc90e7b3f4c9ef42f009f3e346deaa1e7a25756d0801d8"
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

    system "go", "build", *std_go_args(ldflags: ldflags), ".mesheryctlcmdmesheryctl"

    generate_completions_from_executable(bin"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}mesheryctl system start 2>&1", 1)
  end
end