class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.149",
      revision: "7983125ff7f53692eadef3aa1de429b5b47e14fa"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39eac5fa92b5303f07e9f986e20124275c7cb379043d2a287a13f5c5066ded97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39eac5fa92b5303f07e9f986e20124275c7cb379043d2a287a13f5c5066ded97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39eac5fa92b5303f07e9f986e20124275c7cb379043d2a287a13f5c5066ded97"
    sha256 cellar: :any_skip_relocation, sonoma:        "84029f126926c7705e29b9433268d815ceb8d657b76ada624dec244af7bed773"
    sha256 cellar: :any_skip_relocation, ventura:       "84029f126926c7705e29b9433268d815ceb8d657b76ada624dec244af7bed773"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b5b2403962e78a079741b3bdedc145395160f86f1a2a5ebbed216e4d6e22e93"
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