class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.155",
      revision: "80bb1921c6ebf615e9e9472a96c5e8ac08c1b358"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4c07e7a5ccda545bf1e0e7bdefe68eda10dc9da36a3076477d09d1a61346b6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4c07e7a5ccda545bf1e0e7bdefe68eda10dc9da36a3076477d09d1a61346b6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4c07e7a5ccda545bf1e0e7bdefe68eda10dc9da36a3076477d09d1a61346b6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "39cbe783c40d956b44ffcd5098dc1ae0d186edce955cab6b8a3c5fd942d2a51c"
    sha256 cellar: :any_skip_relocation, ventura:       "39cbe783c40d956b44ffcd5098dc1ae0d186edce955cab6b8a3c5fd942d2a51c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d894b7377691a9cfc96064fe15b611bd2df30252fc26ee97fd172f386f5cd80"
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