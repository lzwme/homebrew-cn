class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.29",
      revision: "efb25f913a78b26f432f8982b92b627820dcf236"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "364602cb59107726bc7dc9da003541d71cf551aecdd888ccbac67f8c9187d6f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "364602cb59107726bc7dc9da003541d71cf551aecdd888ccbac67f8c9187d6f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "364602cb59107726bc7dc9da003541d71cf551aecdd888ccbac67f8c9187d6f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed08ea7fe93e7b1c64f925ea8a86074c52a1f48bfeb0aa8007b55dbab279693c"
    sha256 cellar: :any_skip_relocation, ventura:       "ed08ea7fe93e7b1c64f925ea8a86074c52a1f48bfeb0aa8007b55dbab279693c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "801773c1ba2cbe5c5e6317b0d0288f4773c40d6dd5d29efe92c8202d7472b3bf"
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