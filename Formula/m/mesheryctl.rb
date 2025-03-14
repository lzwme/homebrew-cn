class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.49",
      revision: "9a5ee7fd280e581ea4ba35056ea807d83a6815e2"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27f3952949c9de8596982825c2acb0ef147f14f1152cdcd4c8429f0906500305"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27f3952949c9de8596982825c2acb0ef147f14f1152cdcd4c8429f0906500305"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27f3952949c9de8596982825c2acb0ef147f14f1152cdcd4c8429f0906500305"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e474955891b9f6930e1d3966d5aec63cb568d4673fe374d03a8fc19421dc3aa"
    sha256 cellar: :any_skip_relocation, ventura:       "1e474955891b9f6930e1d3966d5aec63cb568d4673fe374d03a8fc19421dc3aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73e10e835db69e028830528a698e783d7216c25fb344fdb3ff46165895ec17f0"
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