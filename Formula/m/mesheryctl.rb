class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.25",
      revision: "247dc34c36d4aa99a14d14e124c7428375d1c952"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6dca0324a8eaacc01610990d4d3fe374ccac5e2b2d1c52c9c62934dd21c3b4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6dca0324a8eaacc01610990d4d3fe374ccac5e2b2d1c52c9c62934dd21c3b4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6dca0324a8eaacc01610990d4d3fe374ccac5e2b2d1c52c9c62934dd21c3b4c"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d8528fa1ea4f59886019432b70ae1be4e0e6039a1da4bec4ffa6c19e721162a"
    sha256 cellar: :any_skip_relocation, ventura:        "1d8528fa1ea4f59886019432b70ae1be4e0e6039a1da4bec4ffa6c19e721162a"
    sha256 cellar: :any_skip_relocation, monterey:       "1d8528fa1ea4f59886019432b70ae1be4e0e6039a1da4bec4ffa6c19e721162a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c2a53efa46053e9a91243637fb01715f4ad8c9e7bf43dd06aba02e336af159a"
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