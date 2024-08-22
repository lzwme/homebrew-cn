class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.89",
      revision: "f7d4d81d2c8b77d78b87b9e33c33ef71a2d9ed62"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac3a45f18f7ba4685504c069a03dd4eeb8bf51f9a02a1823eda391f45fe3ffde"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac3a45f18f7ba4685504c069a03dd4eeb8bf51f9a02a1823eda391f45fe3ffde"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac3a45f18f7ba4685504c069a03dd4eeb8bf51f9a02a1823eda391f45fe3ffde"
    sha256 cellar: :any_skip_relocation, sonoma:         "440d98349e877b76664df501a38eba7c7d4aa2a95dc0b25a4b4528d5b5656cae"
    sha256 cellar: :any_skip_relocation, ventura:        "440d98349e877b76664df501a38eba7c7d4aa2a95dc0b25a4b4528d5b5656cae"
    sha256 cellar: :any_skip_relocation, monterey:       "440d98349e877b76664df501a38eba7c7d4aa2a95dc0b25a4b4528d5b5656cae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "796fc82b92ba02cf3cef82a87388e818b50b854cbed3e525c88e8c1595201f7d"
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