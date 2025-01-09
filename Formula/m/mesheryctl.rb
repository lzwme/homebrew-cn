class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.8",
      revision: "b515912bd37a56477b81909c55fe98bf825f92b4"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cb84b8a65e369a95d47f7531d1cb78f963df7373503e16ead6de2d3d575886e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cb84b8a65e369a95d47f7531d1cb78f963df7373503e16ead6de2d3d575886e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4cb84b8a65e369a95d47f7531d1cb78f963df7373503e16ead6de2d3d575886e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf3df5d1ef2a91fa8e2f24efa32993ca7ff404bdc5aaeb16cc90ee5a465036fd"
    sha256 cellar: :any_skip_relocation, ventura:       "bf3df5d1ef2a91fa8e2f24efa32993ca7ff404bdc5aaeb16cc90ee5a465036fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e345d75d763b510b6b2ffbd4d1dd91e36e9a7a65d850ab4ffa37675d959d3e5"
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