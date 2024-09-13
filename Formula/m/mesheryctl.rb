class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.100",
      revision: "ffd3ccd32d5ee78e26095cc386fdfceea35a0a99"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4bead2d8fee3cc1468fe4810994fbfe7c9d14d7f1b970388dbd5d252e4638ed1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4bead2d8fee3cc1468fe4810994fbfe7c9d14d7f1b970388dbd5d252e4638ed1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bead2d8fee3cc1468fe4810994fbfe7c9d14d7f1b970388dbd5d252e4638ed1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bead2d8fee3cc1468fe4810994fbfe7c9d14d7f1b970388dbd5d252e4638ed1"
    sha256 cellar: :any_skip_relocation, sonoma:         "57afa49d2822c3538713cee8c289c790ac4a8e8f7160f46d9020b92e609b229e"
    sha256 cellar: :any_skip_relocation, ventura:        "57afa49d2822c3538713cee8c289c790ac4a8e8f7160f46d9020b92e609b229e"
    sha256 cellar: :any_skip_relocation, monterey:       "57afa49d2822c3538713cee8c289c790ac4a8e8f7160f46d9020b92e609b229e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "258b58ad25c68c23b68ad0de681f8e08199ec81455c1c587cfb23fd3a26aef8e"
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