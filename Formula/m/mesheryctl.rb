class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.40",
      revision: "510c3c109739ab2082efd167b41df1ee59592d82"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87f2f2d7132954d2a0697542d7566dce53aac0e30c865a5122dfce03f97e7405"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87f2f2d7132954d2a0697542d7566dce53aac0e30c865a5122dfce03f97e7405"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87f2f2d7132954d2a0697542d7566dce53aac0e30c865a5122dfce03f97e7405"
    sha256 cellar: :any_skip_relocation, sonoma:        "45e711d97407ed598f3f7c8af7c3b37e54b487abd1647ae0d6d5e9a69bcf028a"
    sha256 cellar: :any_skip_relocation, ventura:       "45e711d97407ed598f3f7c8af7c3b37e54b487abd1647ae0d6d5e9a69bcf028a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41f8f1de5e048a87d4db34899708dbbfe43b57d898febd2c84dcd235113c68bb"
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