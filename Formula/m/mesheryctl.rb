class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.9",
      revision: "c45245122205aba7955b7c6af399ccb15c091850"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0facb923f75d963bd6a5f13cb08e78482ac2b6b5276590bbfe93cd0c7d715feb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0facb923f75d963bd6a5f13cb08e78482ac2b6b5276590bbfe93cd0c7d715feb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0facb923f75d963bd6a5f13cb08e78482ac2b6b5276590bbfe93cd0c7d715feb"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a1c9cac21d5bd0e0dca3c4b9e6321393208b3ee6d223bfbc4aef2961eb6cc89"
    sha256 cellar: :any_skip_relocation, ventura:        "9a1c9cac21d5bd0e0dca3c4b9e6321393208b3ee6d223bfbc4aef2961eb6cc89"
    sha256 cellar: :any_skip_relocation, monterey:       "9a1c9cac21d5bd0e0dca3c4b9e6321393208b3ee6d223bfbc4aef2961eb6cc89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce7ab2b60884b595f4f63bc54b542d62b7ff457f0532d2b4f8cf1a7c2325cd63"
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