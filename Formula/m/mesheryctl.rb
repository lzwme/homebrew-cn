class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.81",
      revision: "13e09c50cce9c1fcda34124ea150b5a76b24868a"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0932a86522bd45c9806310487eef80717c627fa038c2489d840479947e7be00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0932a86522bd45c9806310487eef80717c627fa038c2489d840479947e7be00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0932a86522bd45c9806310487eef80717c627fa038c2489d840479947e7be00"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2a5fed627cea42de294c184ec7aaccd180517dab5f6f298ca0926a33386c8f9"
    sha256 cellar: :any_skip_relocation, ventura:       "c2a5fed627cea42de294c184ec7aaccd180517dab5f6f298ca0926a33386c8f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "154fd09dd5a0b02c8107d47100a06f69fa79c0abc91c2e54a35fba49821b5104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98d79184a02cde85c404901c5a77db4f6f768b7c046df079ce43931d9b61417a"
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