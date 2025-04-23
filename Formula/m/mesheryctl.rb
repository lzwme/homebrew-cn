class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.60",
      revision: "e754a92d224dd7c8c4e04c5aabc4596431938feb"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7748545ae0a9b04aaac905c6949430d6d9a4303391e1887fb590e9c9243f55ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7748545ae0a9b04aaac905c6949430d6d9a4303391e1887fb590e9c9243f55ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7748545ae0a9b04aaac905c6949430d6d9a4303391e1887fb590e9c9243f55ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "7aca97ef6d1112d8a9383403b0421f36dc1a07391167ba02730009580171f330"
    sha256 cellar: :any_skip_relocation, ventura:       "7aca97ef6d1112d8a9383403b0421f36dc1a07391167ba02730009580171f330"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55583af8ff08135f8194ad56af31be7bc029a3a671ac7492a8c48339df3cbc1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dd9a7867a0ee5cb21e0a80094f257cfb883b017435b1ad14fc9676f1bf01fe0"
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