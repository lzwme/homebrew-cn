class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.106",
      revision: "883d2777f65b55e96f4b605d9bb4ba6b1f17c274"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c05f4e2e7c3794ee0c6d1048f14afe6b9dc193077ca785165259ce682f50be97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c05f4e2e7c3794ee0c6d1048f14afe6b9dc193077ca785165259ce682f50be97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c05f4e2e7c3794ee0c6d1048f14afe6b9dc193077ca785165259ce682f50be97"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f79846348dbc82892a30152bd5f8caf073ef488d7fd2ce9f6dcba3e94ec4669"
    sha256 cellar: :any_skip_relocation, ventura:       "9f79846348dbc82892a30152bd5f8caf073ef488d7fd2ce9f6dcba3e94ec4669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e4b212d2230b86127a02d3c0bf25f933956f0dc45ed95c62984d12e5fe4b63f"
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