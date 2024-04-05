class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.44",
      revision: "d2b48b5c1b03acb2e4ba957bf4cb0c4549bbc5ef"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed946d1f04e634c56eaf89b2d913e7f6ca82a226d030d83a170fc474aaef360e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed946d1f04e634c56eaf89b2d913e7f6ca82a226d030d83a170fc474aaef360e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed946d1f04e634c56eaf89b2d913e7f6ca82a226d030d83a170fc474aaef360e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e894c7be02a19e0e5788317eff23650fddd03f0c54e99cb2e2895986c52dac93"
    sha256 cellar: :any_skip_relocation, ventura:        "e894c7be02a19e0e5788317eff23650fddd03f0c54e99cb2e2895986c52dac93"
    sha256 cellar: :any_skip_relocation, monterey:       "e894c7be02a19e0e5788317eff23650fddd03f0c54e99cb2e2895986c52dac93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a8413e5f1fb6600d025d81d34647efca5387dec60f7ea68bde91f4cffae8d36"
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