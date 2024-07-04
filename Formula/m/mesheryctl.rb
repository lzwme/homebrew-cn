class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.78",
      revision: "65e7d7344026e5f26acb25a117fc3c7c46034870"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "642389960fad504b3fb1f0f10b03fcc33974af95858c6b5d30f33c43b148f48c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "642389960fad504b3fb1f0f10b03fcc33974af95858c6b5d30f33c43b148f48c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "642389960fad504b3fb1f0f10b03fcc33974af95858c6b5d30f33c43b148f48c"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb5f200453494a7de8cf0d4f8abd45aa00061dbb252ebefd8fb0d55ad7d50663"
    sha256 cellar: :any_skip_relocation, ventura:        "bb5f200453494a7de8cf0d4f8abd45aa00061dbb252ebefd8fb0d55ad7d50663"
    sha256 cellar: :any_skip_relocation, monterey:       "bb5f200453494a7de8cf0d4f8abd45aa00061dbb252ebefd8fb0d55ad7d50663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3b9e647e39b2e371b40fd2c817201b7e1e1feaa05fcad307aa8c72c6ecbdf85"
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