class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.136",
      revision: "b3eb929863e9bab3c4fd1b7f76e907a245ee6493"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0db1474859605aacbae36e342bf130f615c0c7573b8360d5caf80217bc669c91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0db1474859605aacbae36e342bf130f615c0c7573b8360d5caf80217bc669c91"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0db1474859605aacbae36e342bf130f615c0c7573b8360d5caf80217bc669c91"
    sha256 cellar: :any_skip_relocation, sonoma:        "a097b3ab56d9a8c153ed889c79a2dfa393af9414843234b79c31c3922242f0d0"
    sha256 cellar: :any_skip_relocation, ventura:       "a097b3ab56d9a8c153ed889c79a2dfa393af9414843234b79c31c3922242f0d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf7c13128dbad3f3156af9f5293a39378b0ced130be2e6a41cb4f4a243fd1a64"
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